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
    assertComplete
    assertCompleteTable
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
              description = "Full (long, descriptive) name of the license";
            };
            shortName = mkOption {
              type = str;
              default = shortName;
              description = ''
                Short name used to identify the license
                In `cudaPackages`, licenses from manifests are grouped by `shortName`s
                and so no two licenses of the same `shortName` may contain conflicting definitions.
              '';
            };
            free = mkOption {
              type = bool;
              default = false;
              description = ''License grants the "four freedoms"'';
            };
            redistributable = mkOption {
              type = bool;
              default = true;
              description = ''License may not be "free" but permits redistribution'';
            };
            deprecated = mkOption {
              type = bool;
              default = false;
              description = "License definition no longer used in Nixpkgs";
            };
            spdxId = mkOption {
              type = nullOr str;
              default = null;
              description = "Optional SPDX Identifier";
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
              description = "Web service for accessing license text";
            };
          };
        }
      );
    in
    {
      # ∷ Str ⇒ ()
      product = mkOption {
        type = SetOfStr;
        default = { };
        example = {
          "cuda" = 1;
          "cudnn" = 1;
          "tensorrt" = 1;
        };
        description = "Corresponds to `release_product` in NVIDIA manifests";
      };

      release = mkColumnOption cudb.product (attrsOf (attrsOf (nullOr str))) {
        default = { };
        description = ''
          `∷ ProductName ⇒ PName ⇒ ProductVersion ⇒ Maybe PackageVersion`

          Packages (`pname`, `version`) published in each release (`productName`, `productVersion)`, or, in NVIDIA manifests, `(release_product, release_label)`)'';
      };

      archive.sha256 = mkOption {
        description = "`∷ SHA256 ⇒ { URL, SystemStringNvidia, CompatibilityTag ⇒ () }`";
        type = attrsOf (submodule {
          options = {
            systemNv = mkOption {
              type = enum (builtins.attrNames cudb.system.nvidia);
              description = "`∷ SystemStringNvidia`";
            };
            tags = mkOption {
              type = SetOfStr;
              default = { };
              description = "`∷ CompatibilityTag ⇒ ()`";
            };
            url = mkOption {
              type = nullOr str;
              description = ''
                `∷ Maybe URI`
                Service to access the archive (e.g. from a FOD)'';
            };
          };
        });
      };

      package =
        let
          index = cudb.package.pname;
        in
        {
          pname = mkOption {
            type = SetOfStr;
            description = ''
              `∷ PName ⇒ ()`

              PNames of known packages'';
          };

          name = mkColumnOption index (nullOr str) {
            description = ''
              `∷ PName ⇒ Maybe String`
            '';
          };

          # ∷ PName ⇒ Version ⇒ Set<SHA256>
          version = mkColumnOption cudb.package.pname (attrsOf SetOfStr) {
            description = ''
              `∷ PName ⇒ Version ⇒ SHA256 ⇒ ()`

              For each `pname`, lists known versions of the package, with
              references to the corresponding `archive.sha256` entries.
            '';
          };

          # ∷ PName ⇒ Set<SystemStringNvidia>
          systemsNv = mkColumnOption index SetOfStr {
            example = {
              libcublas = {
                linux-aarch64 = 1;
                linux-sbsa = 1;
                linux-x86_64 = 1;
              };
            };
            description = ''
              `∷ PName ⇒ SystemStringNvidia ⇒ ()`

              (NVIDIA) system strings for which package has ever been published
            '';
          };

          # ∷ PName ⇒ LicenseShortName
          license =
            mkColumnOption index
              (
                let
                  licenseNames = builtins.attrNames config.license.shortName;
                in
                enum licenseNames
              )
              {
                description = "`∷ PName ⇒ LicenseShortName`";
              };

          outputs = mkColumnOption index (attrsOf bool) {
            description = ''
              `∷ PName ⇒ OutputName ⇒ Bool`
            '';
            apply = lib.mapAttrs (pname: outputs: lib.filterAttrs (_outputName: enable: enable) outputs);
          };
          overrideLicenseUrl = mkColumnOption index (nullOr str) {
            description = ''
              `∷ PName ⇒ Maybe Url`

              In `cudaPackages`, licenses are grouped by `shortName`.
              Certain releases, e.g. `redist/cuda`, publish an independent copy
              of the same license ("CUDA Toolkit") for multiple packages.
              We retain URLs of these copies in `overrideLicenseUrl`.
            '';
          };
        };

      output = mkOption {
        type = SetOfStr;
        description = "Known output names";
      };

      license =
        let
          index = cudb.license.shortName;
        in
        {
          # ∷ String ⇒ ()
          shortName = mkOption {
            type = attrsOf Unit;
            description = ''
              `∷ String ⇒ ()`

              Identifies a license
            '';
          };

          distribution_path = mkColumnOption index (nullOr str) {
            example."CUDA Toolkit" = "cutensor/redist/";
            description = ''
              `∷ String ⇒ Maybe String`

              Attribute from NVIDIA manifests used to form the download URL
            '';
          };

          license_path = mkColumnOption index (nullOr str) {
            example."CUDA Toolkit" = "cuda_cudart/LICENSE.txt";
            description = ''
              `∷ String ⇒ Maybe String`

              Attribute from NVIDIA manifests used to form the download URL
            '';
          };

          compiled = mkColumnOption index License {
            description = ''
              `∷ String ⇒ License`

              Data in `lib.licenses` format, to be used directly in `meta.license`
            '';
          };
        };

      system =
        let
          index = cudb.system.nvidia;
        in
        {
          # ∷ SystemStringNvidia ⇒ ()
          nvidia = mkOption {
            type = SetOfStr;
            description = "`∷ SystemStringNvidia ⇒ ()`";
          };
          # ∷ SystemStringNvidia ⇒ System ⇒ ()
          fromNvidia = mkColumnOption index (attrsOf Unit) {
            description = ''
              `∷ SystemStringNvidia ⇒ SystemStringNix ⇒ ()`


              List of (Nixpkgs) platforms corresponding to the NVIDIA system strings
            '';
          };
          isSource = mkColumnOption index bool {
            description = ''
              ` ∷ SystemStringNvidia ⇒ Bool`

              Whether system string marks a source release
            '';
            example = {
              source = true;
              linux-sbsa = false;
            };
          };
          isJetson = mkColumnOption index bool {
            description = ''
              `∷ SystemStringNvidia ⇒ Bool`

              Whether system string marks a jetson release
            '';
            example = {
              source = false;
              linux-sbsa = false;
              linux-aarch64 = true;
            };
          };
          jetsonCompatible = mkColumnOption index bool {
            description = ''
              `∷ SystemStringNvidia ⇒ Bool`

              Whether system string marks a release compatible with Jetson
            '';
            example = {
              source = true;
              linux-sbsa = false;
              linux-aarch64 = true;
            };
          };
        };

      base_url = mkOption {
        type = str;
        description = "Base URL for redistributable packages";
        default = "https://developer.download.nvidia.com/compute/";
      };
      trt_base_url = mkOption {
        type = str;
        description = "Base URL for (non-redistributable) TensorRT packages";
        default = "https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/{versionTriple}/tars/";
      };

      assertions = mkOption {
        type = listOf types.unspecified;
        default = [ ];
        description = "Assertions checked by `tests.cuda.db` when accessing `validConfig`";
        apply = builtins.filter ({ assertion, ... }: !assertion);
      };
    };
  imports = [ ./bootstrap/static.nix ];
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
        outputs = lib.mapAttrs (_: _: lib.mkDefault { out = true; }) pname;
        overrideLicenseUrl = lib.mapAttrs (_: _: lib.mkDefault null) pname;
        version = lib.mapAttrs (_: _: lib.mkDefault { }) pname;
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
      ++ assertCompleteTable "pname" cudb.package
      ++ assertCompleteTable "shortName" cudb.license
      ++ assertCompleteTable "nvidia" cudb.system
      ++ lib.mapAttrsToList (pname: outputs: {
        message = "package.output.${pname} must have at least one output enabled";
        assertion = builtins.any lib.id (builtins.attrValues outputs);
      }) cudb.package.outputs
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
