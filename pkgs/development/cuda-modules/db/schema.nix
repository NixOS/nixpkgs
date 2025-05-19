{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.types)
    attrsOf
    bool
    enum
    listOf
    nullOr
    str
    submodule
    ;

  Unit = enum [ 1 ];
  SetOfStr = attrsOf Unit;

  columnar = import ./columnar.nix;
  cudb = config;
in
{
  options =
    let
      License = submodule (
        { name, config, ... }:
        let
          shortName = name;
        in
        {
          options = {
            fullName = mkOption {
              type = str;
              default = config.shortName;
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
              default =
                let
                  ensureComposable = base: if lib.hasSuffix "/" base then base else "${base}/";
                  base_url = ensureComposable cudb.base_url;
                  distribution_path = ensureComposable cudb.licenses.distribution_path.${name};
                  license_path = cudb.licenses.license_path.${name};
                in
                "${base_url}${distribution_path}${license_path}";
              defaultText = "\${base_url}\${distribution_path}\${license_path}";
            };
          };
        }
      );
    in
    {
      packages = {
        pnames = mkOption {
          type = SetOfStr;
        };
        name = mkOption {
          type = attrsOf (nullOr str);
        };
        # :: PName -> SystemStringNvidia
        systemsNv = mkOption {
          type = attrsOf SetOfStr;
          default = { };
          example = {
            libcublas = {
              linux-aarch64 = 1;
              linux-sbsa = 1;
              linux-x86_64 = 1;
            };
          };
        };
        # :: PName -> LicenseShortName
        license = mkOption {
          type =
            let
              licenseNames = builtins.attrNames config.licenses.shortNames;
            in
            attrsOf (enum licenseNames);
        };
        # :: PName -> Option<Url>
        overrideLicenseUrl = mkOption {
          type = attrsOf (nullOr str);
        };
      };
      licenses = {
        # :: Str -> ()
        shortNames = mkOption {
          type = attrsOf Unit;
        };
        # :: Str -> Option<Str>
        distribution_path = mkOption {
          type = attrsOf (nullOr str);
          example."CUDA Toolkit" = "cutensor/redist/";
        };
        # :: Str -> Option<Str>
        license_path = mkOption {
          type = attrsOf (nullOr str);
          example."CUDA Toolkit" = "cuda_cudart/LICENSE.txt";
        };
        # :: Str -> License
        compiled = mkOption {
          type = attrsOf License;
          default = { };
        };
      };
      # :: SystemStringNvidia -> ()
      systems.nvidia = mkOption {
        type = SetOfStr;
      };
      # :: SystemStringNvidia -> System -> ()
      systems.fromNvidia = mkOption {
        type = attrsOf (attrsOf Unit);
      };
      # :: SystemStringNvidia -> Bool
      systems.isSource = mkOption {
        type = attrsOf bool;
      };
      # :: SystemStringNvidia -> Bool
      systems.isJetson = mkOption {
        type = attrsOf bool;
      };
      systems.jetsonCompatible = mkOption {
        type = attrsOf bool;
      };
      base_url = mkOption {
        type = str;
        default = "https://developer.download.nvidia.com/compute/";
      };

      assertions = mkOption {
        type = listOf types.unspecified;
        default = [ ];
      };
    };
  imports = [ ./static.nix ];
  config = {
    assertions = builtins.filter ({ assertion, ... }: !assertion) (
      columnar.domainAssertions "license" "shortNames" cudb.licenses
      ++ columnar.domainAssertions "packages" "pnames" cudb.packages
    );
    licenses =
      let
        inherit (cudb.licenses) shortNames;
      in
      {
        compiled = lib.mapAttrs (
          shortName: _: lib.mkDefault (lib.licenses.nvidiaProprietary // { inherit shortName; })
        ) shortNames;
        license_path = lib.mapAttrs (_: _: lib.mkDefault null) shortNames;
        distribution_path = lib.mapAttrs (_: _: lib.mkDefault null) shortNames;
      };
    packages =
      let
        inherit (cudb.packages) pnames;
      in
      {
        name = lib.mapAttrs (pname: _: lib.mkDefault pname) pnames;
        license = lib.mapAttrs (_: _: lib.mkDefault lib.licenses.nvidiaProprietary.shortName) pnames;
        systemsNv = lib.mapAttrs (_: _: lib.mkDefault { }) pnames;
        overrideLicenseUrl = lib.mapAttrs (_: _: lib.mkDefault null) pnames;
      };
    systems = {
      fromNvidia = lib.mapAttrs (_: _: lib.mkDefault { }) cudb.systems.nvidia;
    };
  };
}
