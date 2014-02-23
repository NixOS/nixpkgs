{pkgs, php, lib, writeText, config, pool}:

# yes - PHP 5.2 should no longer be used. I know
# note that only one setup (with many pools) can be used
# because only one configuration file is supported.

let 

  inherit (lib) concatStringsSep maybeAttr;
  inherit (builtins) getAttr isString isInt isAttrs attrNames;

  # id: a uniq identifier based on php version and fpm-daemon config (php ini)
  id = config.id;
  name = "php-fpm-${id}";

defaultConfig = {
    # jobName = ..
    pid = "/var/run/${name}.pid";
    error_log = "/var/log/${name}.log";
    log_level = "notice";
    emergency_restart_threshold = "10";
    emergency_restart_interval = "1m";
    process_control_timeout = "5s";
    daemonize = "no";
    listen = { # xml: listen_options
      backlog = "-1";
      owner = "nobody";
      group = "nogroup";
      mode = "0777";
    };
    commonPoolConfig = {
    };
  };

  defaultPoolConfig = {
    request_terminate_timeout = "305s";
    request_slowlog_timeout = "30s";
    rlimit_files = "1024";
    rlimit_core = "0";
    chroot = "";
    chdir = "";
    catch_workers_output = "yes";
    max_requests = "500";
    allowed_clients = "127.0.0.1";
    environment = {
    };
    pm = {
      style = "static";
      max_children = "5";
      apache_like = {
        StartServers = 20;
        MinSpareServers = 5;
        MaxSpareServers = 35;
      };
    };
  };

  createPHPFpmConfig52 = config: pool:
   let 
     options = a: names:
      concatStringsSep "\n" (map (n: xmlOption n (getAttr n a)) names);

     xmlOption = name: value: 
      if isString value
      then "<value name=\"${name}\">${value}</value>"
      else if isInt value
      then "<value name=\"${name}\">${toString value}</value>"
      else 
        ''
        <value name="${name}">
          ${options value (attrNames value)}
        </value>
        '';
     poolToConfig = poolC: ''
      <section name="pool">
        ${options poolC [ "name" "listen_address" ] }
          <value name = "listen_options">
          ${options poolC.listen (attrNames poolC.listen) }
          </value>
        ${options 
          poolC [
            "user" "group"
            "request_terminate_timeout"
            "request_slowlog_timeout"
            "slowlog"
            "rlimit_files"
            "rlimit_core"
            "chroot"
            "chdir"
            "catch_workers_output"
            "max_requests"
            "allowed_clients"
            "environment"
            "pm"
          ]}
      </section>
       '';
    in
      # main config which pools
      writeText "php-fpm" ''
      <?xml version="1.0" ?>
        <configuration>
          <section name="global_options">
            ${xmlOption "pid_file" config.pid}
            ${options config [
              "error_log" "log_level"
              "emergency_restart_threshold" "emergency_restart_interval"
              "process_control_timeout" "daemonize"
              ]}}
          </section>
          <workers>
          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {} config // poolC)) pool)}
          </workers>
        </configuration>
      '';

      cfg = defaultConfig // config;
      cfgFile =  createPHPFpmConfig52 (cfg) (pool);
in {
  # must be in /etc .., there is no command line flag for PHP 5.2
  environment.etc."php-fpm-5.2.conf".source = cfgFile;

  systemd.services = 
    let name = "php-fpm-${id}";
    in builtins.listToAttrs [{
      inherit name;
      value = {
        description = "The PHP 5.2 FastCGI Process Manager ${id}";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          PIDFile = cfg.pid;
          ExecStart = "${php}/sbin/php-fpm start";
          ExecReload= "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
          ExecStop  = "${pkgs.coreutils}/bin/kill -9 $MAINPID";
          PrivateTmp=true;
        };
        environment =
          lib.optionalAttrs (config.phpIni != null) {
            PHPRC = config.phpIni;
          };
        };
    }];
}
