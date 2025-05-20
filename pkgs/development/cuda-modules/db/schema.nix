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

  inherit (import ./columnar.nix)
    Unit
    SetOfStr
    mkColumnOption
    assertSubset
    ;

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
                  distribution_path = ensureComposable cudb.license.distribution_path.${name};
                  license_path = cudb.license.license_path.${name};
                in
                "${base_url}${distribution_path}${license_path}";
              defaultText = "\${base_url}\${distribution_path}\${license_path}";
            };
          };
        }
      );
    in
    {
      # :: Str -> ()
      product = mkOption {
        type = SetOfStr;
        default = { };
      };

      # :: ProductName -> PName -> ProductVersion -> Option<PackageVersion>
      release = mkColumnOption cudb.product {
        type = attrsOf (attrsOf (nullOr str));
        default = { };
      } { default = { }; };

      # :: PName -> Version -> Set<SHA256>
      archive.bucket = mkColumnOption cudb.package.pname {
        type = attrsOf SetOfStr;
        default = { };
      } { };
      archive.sha256 = mkOption {
        type = attrsOf (submodule {
          options = {
            systemNv = mkOption {
              type = enum (builtins.attrNames cudb.system.nvidia);
            };
            tags = mkOption {
              type = SetOfStr;
              default = { };
            };
            url = mkOption {
              type = nullOr str;
            };
          };
        });
      };

      package =
        let
          index = cudb.package.pname;
        in
        {
          pname = mkOption { type = SetOfStr; };

          # :: PName -> Option<String>
          name = mkColumnOption index { type = nullOr str; } { };

          # :: PName -> Set<SystemStringNvidia>
          systemsNv = mkColumnOption index { type = SetOfStr; } {
            example = {
              libcublas = {
                linux-aarch64 = 1;
                linux-sbsa = 1;
                linux-x86_64 = 1;
              };
            };
          };

          # :: PName -> LicenseShortName
          license = mkColumnOption index {
            type =
              let
                licenseNames = builtins.attrNames config.license.shortName;
              in
              enum licenseNames;
          } { };

          # :: PName -> Option<Url>
          overrideLicenseUrl = mkColumnOption index { type = nullOr str; } { };
        };

      license =
        let
          index = cudb.license.shortName;
        in
        {
          # :: String -> ()
          shortName = mkOption {
            type = attrsOf Unit;
          };

          # :: String -> Option<String>
          distribution_path =
            mkColumnOption index
              {
                type = nullOr str;
              }
              {
                example."CUDA Toolkit" = "cutensor/redist/";
              };

          # :: String -> Option<String>
          license_path =
            mkColumnOption index
              {
                type = nullOr str;
              }
              {
                example."CUDA Toolkit" = "cuda_cudart/LICENSE.txt";
              };

          # :: String -> License
          compiled = mkColumnOption index { type = License; } { };
        };

      system =
        let
          index = cudb.system.nvidia;
        in
        {
          # :: SystemStringNvidia -> ()
          nvidia = mkOption {
            type = SetOfStr;
          };
          # :: SystemStringNvidia -> System -> ()
          fromNvidia = mkColumnOption index {
            type = attrsOf Unit;
          } { };
          # :: SystemStringNvidia -> Bool
          isSource = mkColumnOption index {
            type = bool;
          } { };
          # :: SystemStringNvidia -> Bool
          isJetson = mkColumnOption index {
            type = bool;
          } { };
          jetsonCompatible = mkColumnOption index {
            type = bool;
          } { };
        };

      base_url = mkOption {
        type = str;
        description = "Base URL for redistributable packages";
        default = "https://developer.download.nvidia.com/compute/";
      };
      trt_base_url = mkOption {
        type = str;
        description = "Base URL for (non-redistributable) TensorRT packages";
      };

      assertions = mkOption {
        type = listOf types.unspecified;
        default = [ ];
      };
    };
  imports = [ ./static.nix ];
  config = {
    license =
      let
        shortNames = cudb.license.shortName;
      in
      {
        compiled = lib.mapAttrs (
          shortName: _: lib.mkDefault (lib.licenses.nvidiaProprietary // { inherit shortName; })
        ) shortNames;
        license_path = lib.mapAttrs (_: _: lib.mkDefault null) shortNames;
        distribution_path = lib.mapAttrs (_: _: lib.mkDefault null) shortNames;
      };
    package =
      let
        inherit (cudb.package) pname;
      in
      {
        name = lib.mapAttrs (pname: _: lib.mkDefault pname) pname;
        license = lib.mapAttrs (_: _: lib.mkDefault lib.licenses.nvidiaProprietary.shortName) pname;
        systemsNv = lib.mapAttrs (_: _: lib.mkDefault { }) pname;
        overrideLicenseUrl = lib.mapAttrs (_: _: lib.mkDefault null) pname;
      };
    system = {
      fromNvidia = lib.mapAttrs (_: _: lib.mkDefault { }) cudb.system.nvidia;
    };
    assertions =
      [
        {
          message = "TensorRT license can't be redistributable";
          assertion = !cudb.license.compiled.${cudb.package.license.tensorrt}.redistributable;
        }
      ]
      ++ lib.flatten (
        builtins.attrValues (
          lib.mapAttrs (
            product: pnameVersions:
            assertSubset "package.pname" cudb.package.pname "release.${product}" pnameVersions
          ) cudb.release
        )
      );
  };
}
