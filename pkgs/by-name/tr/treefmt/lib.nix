{
  lib,
  pkgs,
  treefmt,
}:
{
  /**
    Evaluate a treefmt configuration.

    # Type

    ```
    Module -> Configuration
    ```

    # Inputs

    `module`
    : A treefmt module, configuring options that include:
      - `name`: `String` (default `"treefmt-with-config"`)
      - `settings`: `Module` (default `{ }`)
      - `runtimeInputs`: `[Derivation]` (default `[ ]`)
  */
  evalConfig =
    module:
    lib.evalModules {
      class = "treefmtConfig";
      specialArgs.modulesPath = ./modules;
      modules = [
        {
          _file = "treefmt.evalConfig";
          _module.args.pkgs = lib.mkOptionDefault pkgs;
          package = lib.mkOptionDefault treefmt;
        }
        {
          _file = "<treefmt.evalConfig args>";
          imports = lib.toList module;
        }
        ./modules/default.nix
      ];
    };

  /**
    Wrap treefmt, configured using structured settings.

    # Type

    ```
    Module -> Derivation
    ```

    # Inputs

    `module`
    : A treefmt module, configuring options that include:
      - `name`: `String` (default `"treefmt-with-config"`)
      - `settings`: `Module` (default `{ }`)
      - `runtimeInputs`: `[Derivation]` (default `[ ]`)
  */
  withConfig =
    module:
    let
      configuration = treefmt.evalConfig {
        _file = "<treefmt.withConfig args>";
        imports = lib.toList module;
      };
    in
    configuration.config.result;

  /**
    Build a treefmt config file from structured settings.

    # Type

    ```
    Module -> Derivation
    ```

    # Inputs

    `settings`
    : A settings module, used to build a treefmt config file
  */
  buildConfig =
    module:
    let
      configuration = treefmt.evalConfig {
        _file = "<treefmt.buildConfig args>";
        settings.imports = lib.toList module;
      };
    in
    configuration.config.configFile.overrideAttrs {
      passthru = {
        inherit (configuration.config) settings;
        options = (opt: opt.type.getSubOptions opt.loc) configuration.options.settings;
      };
    };
}
