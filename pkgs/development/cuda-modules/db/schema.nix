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
      package = {
        pname = mkOption {
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
              licenseNames = builtins.attrNames config.license.shortName;
            in
            attrsOf (enum licenseNames);
        };
        # :: PName -> Option<Url>
        overrideLicenseUrl = mkOption {
          type = attrsOf (nullOr str);
        };
      };
      license = {
        # :: Str -> ()
        shortName = mkOption {
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
      system.nvidia = mkOption {
        type = SetOfStr;
      };
      # :: SystemStringNvidia -> System -> ()
      system.fromNvidia = mkOption {
        type = attrsOf (attrsOf Unit);
      };
      # :: SystemStringNvidia -> Bool
      system.isSource = mkOption {
        type = attrsOf bool;
      };
      # :: SystemStringNvidia -> Bool
      system.isJetson = mkOption {
        type = attrsOf bool;
      };
      system.jetsonCompatible = mkOption {
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
      columnar.domainAssertions "license" "shortName" cudb.license
      ++ columnar.domainAssertions "package" "pname" cudb.package
      ++ columnar.domainAssertions "system" "nvidia" cudb.system
    );
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
  };
}
