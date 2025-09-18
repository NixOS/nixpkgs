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

  config.result =
    pkgs.runCommand config.name
      {
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        env = {
          inherit (config) configFile;
          binPath = lib.makeBinPath config.runtimeInputs;
        };
        passthru = {
          inherit (config) runtimeInputs;
          inherit config options;
        };
        inherit (config.package) meta version;
      }
      ''
        mkdir -p $out/bin
        makeWrapper \
          ${lib.getExe config.package} \
          $out/bin/treefmt \
          --prefix PATH : "$binPath" \
          --add-flags "--config-file $configFile"
      '';
}
