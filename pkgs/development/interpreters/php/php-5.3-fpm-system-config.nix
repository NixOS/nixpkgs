{ php, pkgs, lib, writeText
, config # shared config
, pool   # configuration for each pool
}:

let

  inherit (lib) concatStringsSep maybeAttr;
  inherit (builtins) getAttr isInt isString attrNames toString;

  # id: a uniq identifier based on php version and fpm-daemon config (php ini)
  id = config.id;
  name = "php-fpm-${id}";

  defaultConfig = {
    serviceName = "php-fpm-${id}";
    pid = "/var/run/${name}.pid";
    error_log = "/var/log/${name}.log";
    log_level = "notice";
    emergency_restart_threshold = "10";
    emergency_restart_interval = "1m";
    process_control_timeout = "5s";
    daemonize = "no";
    commonPoolConfig = {
    };
  };

  cfg = defaultConfig // config;

  defaultPoolConfig = {
    request_terminate_timeout = "305s";
    # slowlog = ..
    request_slowlog_timeout = "30s";
    rlimit_files = "1024";
    rlimit_core = "0";
    chroot = "";
    chdir = "";
    catch_workers_output = "yes";
    allowed_clients = "127.0.0.1";
    # can't use "listen" when using listen attrs
    # listen_address = .. # listen setting
    # listen = {
    #   backlog = "-1";
    #   owner = "nobody";
    #   group = "nogroup";
    #   mode = "0777";
    # };

    environment = {
    };
    pm_type = "dynamic"; # pm setting
    pm = {
      max_children = "5";
      max_requests = "500";
      start_servers = 1;
      min_spare_servers = 1;
      max_spare_servers = 4;
    };
  };

  createConfig = config: pool:
    # listen = 127.0.0.1:${builtins.toString (builtins.add start_port_php_fpm kunde.nr)}
   let
     options = prefix: a: names:
      concatStringsSep "\n" (map (n: option prefix n (getAttr n a)) names);

     option = prefix: name: value:
      if isString value
      then "${prefix}${name} = ${value}\n"
      else if isInt value
      then "${prefix}${name} = ${toString value}\n"
      else "${options "${name}." value (attrNames value)}\n";

     poolToConfig = poolC: ''
      [${poolC.name}]
      ${option "" "listen" (poolC.listen_address)}
      ${option "" "pm" (poolC.pm_type)}
      ${options
          ""
          poolC
          [
            # attrs
            "listen"
            "pm"
            "environment"
            # simple values:
            "user"
            "group"
            "request_terminate_timeout"
            "slowlog"
            "request_slowlog_timeout"
          ]
      }
      ${maybeAttr "extraLines" "" poolC}
      '';
    in
      # main config which pools
      writeText "php-fpm" ''
          [global]
          ${options "" config [
            "pid" "error_log" "log_level" "emergency_restart_threshold"
            "emergency_restart_interval" "process_control_timeout" "daemonize"
          ]}

          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {}  config // poolC)) pool)}
       '';

  configFile = createConfig (cfg) (pool);

in {
  systemd.sockets = 
    builtins.listToAttrs [{
	inherit name;

        value = {
          description="The PHP FastCGI Process Manager ${id} socket";
          wantedBy=["multi-user.target"];
          socketConfig={
	    ListenStream = lib.catAttrs "listen_address" pool;
	  };
	};
      }];

  systemd.services = builtins.listToAttrs [{
	inherit name;
        value = {
	  description =  "The PHP FastCGI Process Manager ${id} service";
	  environment = lib.optionalAttrs (config.phpIni != null) {
	    PHPRC="${config.phpIni}";
	  };
	  serviceConfig = {
	    Type = "simple";
	    PIDFile=cfg.pid;
	    ExecStart="${php}/sbin/php-fpm -y ${configFile}";
	    # TODO: test this:
	    ExecReload="${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
	    ExecStop="${pkgs.coreutils}/bin/kill -9 $MAINPID";
	    PrivateTmp=true;
	  };
	};
      }];
}
