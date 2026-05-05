# Non-module dependencies (`importApply`)
{ timetagger }:

{
  config,
  lib,
  ...
}:
let
  cfg = config.timetagger;
in
{
  _class = "service";
  options.timetagger = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "The timetagger package that provided this module.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Which port this service should listen on.";
    };
    addr = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Which addr this service should run on.";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = timetagger.overrideAttrs (prev: {
        passthru = (prev.passthru or { }) // {
          inherit (cfg) port addr;
        };
      });
      defaultText = "package overriden with port and addr";
      description = "Final package constructed from `options.timetagger.package`";
    };
  };
  config = {
    process.argv = [
      (lib.getExe cfg.package)
    ];
    timetagger.package = cfg.finalPackage;
  };
  meta.maintainers = (cfg.package.meta.maintainers or [ ]);
}
