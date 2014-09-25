node[:deploy].each do |appname, deployconfig|
  # determine root folder of new app deployment
  approot = "#{deployconfig[:deployto]}/current"

  # use template .redis.yml.erb. to generate 'config/redis.yml'
  template "#{approot}/config/redis.yml" do
    source "redis.yml.erb"
    cookbook "redis-config"

    # set mode, group and owner of generated file
    mode "0660"
    group deployconfig[:group]
    owner deployconfig[:user]

    # define variable .@redis. to be used in the ERB template
    variables(:redis => deployconfig[:redis] || {})

    # only generate a file if there is Redis configuration
    not_if do
      deploy_config[:redis].blank?
    end
  end
end
