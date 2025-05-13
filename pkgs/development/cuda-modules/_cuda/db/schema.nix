{ lib, config, ... }:
let
  inherit (lib) mkOption types literalExpression;
  inherit (lib.types)
    attrsOf
    bool
    enum
    listOf
    nullOr
    str
    submodule
    mkOptionType
    ;

  inherit (import ./columnar.nix)
    unit
    Unit
    SetOfStr
    mkColumnOption
    assertSubset
    assertCompleteTable
    ;

  bootstrapData = import ./bootstrap { inherit lib; } // {
    _file = ./bootstrap;
  };
  mergeByLength =
    getLength: loc: defs:
    if defs == [ ] then
      abort "This case should never happen."
    else if lib.length defs == 1 then
      (lib.head defs).value
    else
      (lib.foldl' (
        a: b:
        let
          aLen = getLength a.value;
          bLen = getLength b.value;
        in
        if a.value == b.value then
          a
        else if aLen > bLen then
          a
        else if bLen > aLen then
          b
        else
          throw "The option `${lib.showOption loc}' has conflicting definition values of same length:${
            lib.options.showDefs [
              a
              b
            ]
          }"
      ) (lib.head defs) (lib.tail defs)).value;
  StrByLength = mkOptionType {
    name = "StrByLength";
    description = "string (merged by choosing longest)";
    descriptionClass = "noun";
    check = lib.isString;
    merge = mergeByLength lib.stringLength;
  };

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
              type = nullOr StrByLength;
              default =
                let
                  ensureComposable = lib.mapNullable (
                    base:
                    assert builtins.isString base || builtins.isPath base;
                    if lib.hasSuffix "/" base then base else "${base}/"
                  );
                  base_url = ensureComposable cudb.base_url;
                  distribution_path = ensureComposable (cudb.license.distribution_path.${name} or null);
                  license_path = cudb.license.license_path.${name} or null;
                in
                "${base_url}${distribution_path}${license_path}";
              defaultText = literalExpression "${cudb.base_url}\${distribution_path}\${license_path}";
              description = "Web service for accessing license text";
            };
          };
        }
      );
      CapabilityInfo = submodule (
        { name, ... }:
        {
          options = {
            archName = mkOption {
              type = types.nonEmptyStr;
              description = ''
                Microarchitecture family name
              '';
              example = "Blackwell";
            };
            cudaCapability = mkOption {
              type = types.uniq types.nonEmptyStr;
              default = name;
              description = ''
                A PTX feature set.

                A dot-separated version string (device compute capability, [CC](https://web.archive.org/web/20250519224130/https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capability)), followed by optional suffix "a" ("architecture"-specific) or "f" ("family"-specific), identifies a set of PTX instructions and features. By a slight abuse of terminology, Nixpkgs refers to PTX compilation targets as to "cuda capabilities", and uses the version string notation (`"10.0f"` for `"compute_100f"`).
              '';
              example = "10.0a";
            };
            isJetson = mkOption {
              type = bool;
              default = false;
              description = ''
                Marks a feature set corresponding to Jetson embedded devices.

                Corresponds to the `"linux-aarch64"` system string in NVIDIA manifests, as distinguished from e.g. `"linux-sbsa"` (binaries for `aarch64-linux` hosts with external PCI-e GPUs).
              '';
            };
            isArchitectureSpecific = mkOption {
              type = bool;
              default = lib.hasSuffix "a" name;
              defaultText = literalExpression ''hasSuffix "a" ${name}'';
              description = ''
                Marks a feature set implemented by a physical architecture. "Architecture-specific" compute capabilities are neither forward- nor backward-compatible.
              '';
            };
            isFamilySpecific = mkOption {
              type = bool;
              default = lib.hasSuffix "f" name;
              defaultText = literalExpression ''hasSuffix "f" ${name}'';
              description = ''
                Marks a feature set implemented by a family of architectures, e.g. `"10.0f"` for "compute capabilities supported by and only by Blackwell Data Center GPUs".
              '';
            };
            minCudaMajorMinorVersion = mkOption {
              type = types.nonEmptyStr;
              description = ''
                First CUDAToolkit release featuring binaries for this compute capability.
              '';
            };
            maxCudaMajorMinorVersion = mkOption {
              type = nullOr types.nonEmptyStr;
              description = ''
                Last CUDAToolkit release featuring binaries for this compute capability.
              '';
            };
            dontDefaultAfterCudaMajorMinorVersion = mkOption {
              type = nullOr types.nonEmptyStr;
              description = ''
                CUDAToolkit version after which Nixpkgs no longer includes this capability in default targets. Used to infer defaults compatible with special products such as TensorRT.
              '';
            };
          };
        }
      );
    in
    {
      cudaCapabilityToInfo = mkOption {
        type = attrsOf CapabilityInfo;
        description = ''
          `∷ CapabilityName ⇒ CapabilityInfo`

          Elaborates Nixpkgs cuda capability strings.
        '';
        # example = bootstrapData.cudaCapabilityToInfo;
      };
      cudaArchNameToCapabilities =
        let
          computeDefault = db: allCCs: lib.groupBy (cc: db.cudaCapabilityToInfo.${cc}.archName) allCCs;
        in
        mkOption {
          type = attrsOf (types.nonEmptyListOf types.nonEmptyStr);
          description = ''
            `∷ CudaFamilyName ⇒ List CapabilityName`

            Shorthand for compilation targets corresponding to each CUDA architecture family.
          '';
          default = computeDefault cudb cudb.allSortedCudaCapabilities;
          example = computeDefault bootstrapData (builtins.attrNames bootstrapData.cudaCapabilityToInfo);
          readOnly = true;
          internal = true;
        };

      allSortedCudaCapabilities = mkOption {
        type = types.listOf types.nonEmptyStr;
        description = ''
          `∷ List CapabilityName`

          Shorthand for the sorted list of cuda capability version strings
        '';
        default = lib.sort lib.versionOlder (lib.attrNames cudb.cudaCapabilityToInfo);
        example = lib.sort lib.versionOlder (lib.attrNames bootstrapData.cudaCapabilityToInfo);
        readOnly = true;
        internal = true;
      };

      nvccCompatibilities =
        let
          VersionRange = submodule {
            options = {
              minMajorVersion = mkOption {
                type = types.nonEmptyStr;
                description = "Lower major release of the host compiler supported by NVCC. Not consumed by Nixpkgs in practice";
              };
              maxMajorVersion = mkOption {
                type = types.nonEmptyStr;
                description = "Highest major release of the host compiler supported by NVCC. Consumed e.g. by `cudaPackages.backendStdenv`";
              };
            };
          };
        in
        mkOption {
          type = attrsOf (submodule {
            options = {
              clang = mkOption {
                type = VersionRange;
                description = "Range of supported Clang compilers";
              };
              gcc = mkOption {
                type = VersionRange;
                description = "Range of supported GCC compilers";
              };
            };
          });
          description = ''
            `∷ ProductVersion ⇒ { gcc : MajorVersionRange, clang: MajorVersionRange }`

            Host compilers expected by NVCC in each CUDAToolkit release.
          '';
          example = lib.listToAttrs (lib.take 1 (lib.attrsToList bootstrapData.nvccCompatibilities));
        };

      release = {
        product = mkOption {
          type = SetOfStr;
          default = { };
          example = {
            "cuda" = unit;
            "cudnn" = unit;
            "tensorrt" = unit;
          };
          description = ''
            `∷ ProductName ⇒ ()`

            Corresponds to `release_product` in NVIDIA manifests
          '';
        };

        package = mkColumnOption cudb.product (attrsOf (attrsOf (nullOr str))) {
          default = { };
          description = ''
            `∷ ProductName ⇒ ProductVersion ⇒ PName ⇒ Maybe PackageVersion`

            Packages (`pname`, `version`) published in each release (`(productName, productVersion)`),
            or, in NVIDIA manifests, `(release_product, release_label)`)
          '';
        };
      };

      archive.sha256 = mkOption {
        description = "`∷ SHA256 ⇒ { URL, SystemStringNvidia, CompatibilityTag ⇒ () }`";
        default = { };
        type = attrsOf (submodule {
          options = {
            systemNv = mkOption {
              type = enum (builtins.attrNames cudb.system.nvidia);
              description = "`∷ SystemStringNvidia`";
            };
            extraConstraints = mkOption {
              default = { };
              description = "`∷ CompatibilityTag ⇒ ()`";
              type = attrsOf (
                submodule (
                  { name, ... }:
                  {
                    options = {
                      "<" = lib.mkOption {
                        type = nullOr str;
                        default = null;
                        description = ''
                          `∷ VersionString`

                          Package or product ${name} must be `versionOlder version ${name}.version`.
                        '';
                      };
                      ">=" = lib.mkOption {
                        type = nullOr str;
                        default = null;
                        description = ''
                          `∷ VersionString`

                          Package or product ${name} must be `versionAtLeast version ${name}.version`.
                        '';
                      };
                    };
                  }
                )
              );
            };
            url = mkOption {
              type = nullOr StrByLength;
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

          name = mkColumnOption index (nullOr StrByLength) {
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
                linux-aarch64 = unit;
                linux-sbsa = unit;
                linux-x86_64 = unit;
              };
            };
            description = ''
              `∷ PName ⇒ SystemStringNvidia ⇒ ()`

              (NVIDIA) system strings for which package has ever been published
            '';
          };

          # ∷ PName ⇒ LicenseShortName
          license =
            let
              licenseNames = builtins.attrNames config.license.shortName;
            in
            mkColumnOption index

              (enum licenseNames // { merge = mergeByLength lib.stringLength; })
              { description = "`∷ PName ⇒ LicenseShortName`"; };

          outputs = mkColumnOption index (attrsOf bool) {
            description = ''
              `∷ PName ⇒ OutputName ⇒ Bool`
            '';
            apply = lib.mapAttrs (pname: outputs: lib.filterAttrs (_outputName: enable: enable) outputs);
          };
          overrideLicenseUrl = mkColumnOption index (nullOr StrByLength) {
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

          distribution_path = mkColumnOption index (nullOr StrByLength) {
            example."CUDA Toolkit" = "cutensor/redist/";
            description = ''
              `∷ String ⇒ Maybe String`

              Attribute from NVIDIA manifests used to form the download URL
            '';
          };

          license_path = mkColumnOption index (nullOr StrByLength) {
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
  imports = [ bootstrapData ];
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
        lib.mapAttrsToList (
          product: releasePackages:
          lib.mapAttrsToList (
            productVersion: pnameVersions:
            assertSubset "package.pname" cudb.package.pname "release.${product}" pnameVersions
            ++ [
              {
                message = ''release."${product}"."${productVersion}" contains values not declared in `package.version`'';
                assertion = builtins.all lib.id (
                  lib.mapAttrsToList (
                    pname: version: cudb.package.version.${pname}.${version} or null != null
                  ) pnameVersions
                );
              }
            ]
          ) releasePackages
        ) cudb.release.package
      );
  };
}
