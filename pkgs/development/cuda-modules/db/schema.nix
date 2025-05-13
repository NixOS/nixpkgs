{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    attrsOf
    nullOr
    bool
    str
    submodule
    enum
    ;

  Unit = enum [ "" ];
  SetOfStr = attrsOf Unit;

  cudb = config;
in
{
  imports = [
  ];
  options =
    let
      Recipe = submodule (
        { name, ... }:
        let
          pname = name;
        in
        {
          options = {
            pname = mkOption {
              type = str;
              default = pname;
            };
            name = mkOption {
              type = nullOr str;
              default = null;
            };
            platforms = mkOption {
              type = SetOfStr;
              default = { };
              description = "All platforms potentially supported by the package";
            };
            license = mkOption {
              type = enum (builtins.attrNames config.licenses);
              default = "${pname} EULA";
              defaultText = "\${pname} EULA";
            };
          };
        }
      );
      License = submodule (
        { name, config, ... }:
        let
          shortName = name;
        in
        {
          options = {
            distribution_path = mkOption {
              type = nullOr str;
              example = "cutensor/redist/";
            };
            license_path = mkOption {
              type = nullOr str;
              # default = "cuda_cudart/LICENSE.txt";
            };
            compiled = {
              fullName = mkOption {
                type = str;
                default = config.compiled.shortName;
                defaultText = "<shortName>";
              };
              shortName = mkOption {
                type = str;
                default = shortName;
                defaultText = "<name>";
              };
              free = mkOption {
                type = bool;
                default = false;
              };
              redistributable = mkOption {
                type = bool;
                default = true;
              };
              deprecated = mkOption {
                type = bool;
                default = false;
              };
              spdxId = mkOption {
                type = nullOr str;
                default = null;
              };
              url = mkOption {
                type = nullOr str;
                default = "${cudb.base_url}${config.distribution_path}${config.license_path}";
                defaultText = "\${cudb.base_url}\${distribution_path}\${license_path}";
              };
            };
          };
        }
      );
    in
    {
      recipes = mkOption {
        default = { };
        type = attrsOf Recipe;
      };
      licenses = mkOption {
        default = { };
        type = attrsOf License;
      };
      base_url = mkOption {
        type = str;
        default = "https://developer.download.nvidia.com/compute/";
      };
    };
  config = {
    licenses =
      let
        redist = lib.licenses.nvidiaCudaRedist;
        legacy = lib.licenses.nvidiaCuda;
      in
      {
        "${redist.shortName}" = {
          compiled = redist;
        };
        "${legacy.shortName}" = {
          compiled = redist;
          distribution_path = lib.mkDefault null;
          license_path = lib.mkDefault null;
        };
        "MIT" = {
          compiled = lib.licenses.mit;
          distribution_path = lib.mkDefault null;
          license_path = lib.mkDefault null;
        };
      };
  };
}
