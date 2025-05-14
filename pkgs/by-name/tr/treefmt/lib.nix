{
  lib,
  runCommand,
  formats,
  treefmt,
  makeBinaryWrapper,
}:
{
  /**
    Wrap treefmt, configured using structured settings.

    # Type

    ```
    AttrSet -> Derivation
    ```

    # Inputs

    - `name`: `String` (default `"treefmt-configured"`)
    - `settings`: `Module` (default `{ }`)
    - `runtimeInputs`: `[Derivation]` (default `[ ]`)
  */
  withConfig =
    {
      name ? "treefmt-with-config",
      settings ? { },
      runtimeInputs ? [ ],
    }:
    runCommand name
      {
        nativeBuildInputs = [ makeBinaryWrapper ];
        treefmtExe = lib.getExe treefmt;
        binPath = lib.makeBinPath runtimeInputs;
        passthru = { inherit runtimeInputs; };
        configFile = treefmt.buildConfig {
          # Wrap user's modules with a default file location
          _file = "<treefmt.withConfig settings arg>";
          imports = lib.toList settings;
        };
        inherit (treefmt) meta version;
      }
      ''
        mkdir -p $out/bin
        makeWrapper \
          $treefmtExe \
          $out/bin/treefmt \
          --prefix PATH : "$binPath" \
          --add-flags "--config-file $configFile"
      '';

  /**
    Build a treefmt config file from structured settings.

    # Type

    ```
    Module -> Derivation
    ```
  */
  buildConfig =
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
        inherit (configuration) _module options;
        optionType = configuration.type;
      };
    };
}
