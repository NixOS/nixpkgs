# Tests in: nixos/tests/php/fpm-modular.nix

# Non-module dependencies (importApply)
{ formats, coreutils }:

# Service module
{
  options,
  config,
  lib,
  ...
}:
let
  cfg = config.php-fpm;
  format = formats.iniWithGlobalSection { };
  configFile = format.generate "php-fpm.conf" {
    globalSection = lib.filterAttrs (_: v: !lib.isAttrs v) cfg.settings;
    sections = lib.filterAttrs (_: lib.isAttrs) cfg.settings;
  };

  poolOpts =
    { name, ... }:
    {
      freeformType =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      options = {
        listen = lib.mkOption {
          type =
            with lib.types;
            oneOf [
              path
              port
              str
            ];
          default = "/run/php-fpm/${name}.sock";
          description = ''
            The address on which to accept FastCGI requests. Valid syntaxes are: `ip.add.re.ss:port`, `port`, `/path/to/unix/socket`.
          '';
        };

        pm = lib.mkOption {
          type = lib.types.enum [
            "static"
            "ondemand"
            "dynamic"
          ];
          description = ''
            Choose how the process manager will control the number of child processes.

            `static` - the number of child processes is fixed (`pm.max_children`).
            `ondemand` - the processes spawn on demand (when requested, as opposed to `dynamic`, where `pm.start_servers` are started when the service is started).
            `dynamic` - the number of child processes is set dynamically based on the following directives: `pm.max_children`, `pm.start_servers`, pm.min_spare_servers, `pm.max_spare_servers`.
          '';
        };

        "pm.max_children" = lib.mkOption {
          type = lib.types.int;
          description = ''
            The number of child processes to be created when `pm` is set to `static` and the maximum
            number of child processes to be created when `pm` is set to `dynamic`.

            This option sets the limit on the number of simultaneous requests that will be served.
          '';
        };

        user = lib.mkOption {
          type = lib.types.str;
          description = ''
            Unix user of FPM processes.
          '';
        };
      };
    };
in
{
  _class = "service";

  options.php-fpm = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "PHP package to use for php-fpm";
      defaultText = lib.literalMD ''The PHP package that provided this module.'';
      example = lib.literalExpression ''
        php.buildEnv {
          extensions =
            { all, ... }:
            with all;
            [
              imagick
              opcache
            ];
          extraConfig = "memory_limit=256M";
        }
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            str
            int
            bool
            (submodule poolOpts)
          ]);
        options = {
          log_level = lib.mkOption {
            type = lib.types.enum [
              "alert"
              "error"
              "warning"
              "notice"
              "debug"
            ];
            default = "notice";
            description = ''
              Error log level.
            '';
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          log_level = "debug";
          log_limit = 2048;

          mypool = {
            "user" = "php";
            "group" = "php";
            "listen.owner" = "caddy";
            "listen.group" = "caddy";
            "pm" = "dynamic";
            "pm.max_children" = 75;
            "pm.start_servers" = 10;
            "pm.min_spare_servers" = 5;
            "pm.max_spare_servers" = 20;
            "pm.max_requests" = 500;
          }
        }
      '';
      description = ''
        PHP FPM configuration. Refer to [upstream documentation](https://www.php.net/manual/en/install.fpm.configuration.php) for details on supported values.
      '';
    };
  };

  config = {
    php-fpm.settings = {
      error_log = "syslog";
      daemonize = false;
    };

    process.argv = [
      "${cfg.package}/bin/php-fpm"
      "-y"
      configFile
    ];
  }
  // lib.optionalAttrs (options ? systemd) {

    systemd.service = {
      after = [ "network.target" ];
      documentation = [ "man:php-fpm(8)" ];

      serviceConfig = {
        Type = "notify";
        ExecReload = "${coreutils}/bin/kill -USR2 $MAINPID";
        RuntimeDirectory = "php-fpm";
        RuntimeDirectoryPreserve = true;
        Restart = "always";
      };
    };

  }
  // lib.optionalAttrs (options ? finit) {

    finit.service = {
      conditions = [ "service/syslogd/ready" ];
      reload = "${coreutils}/bin/kill -USR2 $MAINPID";
      notify = "systemd";
    };
  };

  meta.maintainers = with lib.maintainers; [
    aanderse
  ];
}
