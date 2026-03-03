# Non-module dependencies (importApply)
{ unixtools, apprise }:

# Service module
{
  options,
  config,
  lib,
  ...
}:

let
  cfg = config.uptime-kuma;

  inherit (lib)
    mkEnableOption
    literalExpression
    optionalAttrs
    optional
    mkOption
    maintainers
    types
    getExe
    ;
in
{
  _class = "service";

  options.uptime-kuma = {
    # FIXME: Should this be `mkPackageOption` or something like redlib's `mkModularPackageOption`
    package = mkOption {
      description = "Package to use for uptime-kuma";
      defaultText = "The uptime-kuma package that provided this module.";
      type = types.package;
    };

    appriseSupport = mkEnableOption "apprise support for notifications";

    settings = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      # FIXME: This needs to be looked over by someone who has more experience with modular services
      # Im not sure if these apply the same way as `lib.mkDefault`s do
      # Im unsure how `config.services.uptime-kuma.settings` is supposed to be scoped here so this is what I did
      default = {
        DATA_DIR = "/var/lib/uptime-kuma/";
        NODE_ENV = "production";
        HOST = "127.0.0.1";
        PORT = "3001";
        UPTIME_KUMA_DB_TYPE = "sqlite";
      };
      example = {
        PORT = "4000";
        NODE_EXTRA_CA_CERTS = literalExpression "config.security.pki.caBundle";
        UPTIME_KUMA_DB_TYPE = "mariadb";
        UPTIME_KUMA_DB_HOSTNAME = "localhost";
        UPTIME_KUMA_DB_NAME = "uptime-kuma";
        UPTIME_KUMA_DB_USERNAME = "uptime-kuma";
        UPTIME_KUMA_DB_PASSWORD = "uptime-kuma";
      };
      description = ''
        Additional configuration for Uptime Kuma, see
        <https://github.com/louislam/uptime-kuma/wiki/Environment-Variables>
        for supported values.
      '';
    };
  };

  config = {
    process.argv = [
      (getExe cfg.package)
    ];
  }
  // optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "Uptime Kuma";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      # FIXME: Not sure if the proper way is to get pkgs into scope here or move this elsewhere
      path = [ unixtools.ping ] ++ optional cfg.appriseSupport apprise;
      serviceConfig = {
        Type = "simple";
        StateDirectory = "uptime-kuma";
        StateDirectoryMode = "750";
        DynamicUser = true;
        Restart = "on-failure";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # enabling it breaks execution
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
      };
    };
  };

  meta.maintainers = with maintainers; [ james-1701 ];
}
