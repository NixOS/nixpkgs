{
  lib,
  formats,
}:
module:
let
  settingsFormat = formats.toml { };
  configuration = lib.evalModules {
    modules = [
      {
        freeformType = settingsFormat.type;
      }
      {
        _file = "<treefmt2.buildConfig args>";
        imports = lib.toList module;
      }
    ];
  };
  settingsFile = settingsFormat.generate "treefmt.toml" configuration.config;
in
settingsFile.overrideAttrs {
  passthru = {
    settings = configuration.config;
    inherit (configuration) _module options type;
  };
}
