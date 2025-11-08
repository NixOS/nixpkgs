{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
let
  settingsFormat = pkgs.formats.toml { };
in
{
  options.settings = lib.mkOption {
    type = lib.types.submoduleWith {
      specialArgs = { inherit modulesPath; };
      modules = [
        { freeformType = settingsFormat.type; }
      ];
    };
    default = { };
    description = ''
      Settings used to build a treefmt config file.
    '';
  };

  config.configFile = lib.mkOptionDefault (settingsFormat.generate "treefmt.toml" config.settings);
}
