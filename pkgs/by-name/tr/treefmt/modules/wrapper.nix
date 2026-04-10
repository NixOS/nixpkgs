{
  lib,
  pkgs,
  config,
  options,
  ...
}:
{
  options.result = lib.mkOption {
    type = lib.types.package;
    description = ''
      The wrapped treefmt package.
    '';
    readOnly = true;
    internal = true;
  };

  config.result = pkgs.symlinkJoin {
    pname = config.name;
    inherit (config.package) meta version;
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    paths = [ config.package ];
    env = {
      inherit (config) configFile;
      binPath = lib.makeBinPath config.runtimeInputs;
    };
    passthru = {
      inherit (config) runtimeInputs;
      inherit config options;
    };
    postBuild = ''
      wrapProgram "$out/bin/treefmt" \
        --prefix PATH : "$binPath" \
        --add-flags "--config-file $configFile"
    '';
  };
}
