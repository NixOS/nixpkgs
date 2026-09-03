# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
  cfg = config.trailbase;
in
{
  _class = "service";

  meta = {
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };

  options = {
    trailbase = {
      package = mkOption {
        description = "Package to use for TrailBase.";
        defaultText = "The package that provided this module.";
        type = types.package;
      };

      address = mkOption {
        description = "Authority (`<host>:<port>`) the HTTP server binds to.";
        type = types.str;
        default = "127.0.0.1:4000";
        example = "0.0.0.0:4000";
      };

      depot = mkOption {
        description = "Directory for runtime files including the databases.";
        type = types.str;
        default = "/var/lib/trailbase";
      };

      extraArgs = mkOption {
        description = "Extra arguments to pass to `trail run`.";
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = {
    process.argv = [
      (getExe cfg.package)
      "--depot"
      cfg.depot
      "run"
      "--address"
      cfg.address
    ]
    ++ cfg.extraArgs;
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "TrailBase";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        DynamicUser = true;
        StateDirectory = "trailbase";
        StateDirectoryMode = "0700";
        WorkingDirectory = "%S/trailbase";
        UMask = "0077";
      };
    };
  };
}
