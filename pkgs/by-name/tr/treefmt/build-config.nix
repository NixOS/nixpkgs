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
        _file = ./build-config.nix;
        freeformType = settingsFormat.type;
      }
      {
        # Wrap user's modules with a default file location
        _file = "<treefmt.buildConfig args>";
        imports = lib.toList module;
      }
    ];
  };
  settingsFile = settingsFormat.generate "treefmt.toml" configuration.config;
in
settingsFile.overrideAttrs {
  passthru = {
    format = settingsFormat;
    settings = configuration.config;
    inherit (configuration) _module options type;
  };
}
