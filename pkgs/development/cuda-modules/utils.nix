{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.types)
    attrs
    cudaVariant
    flattenedIndexElem
    indexOf
    packageInfo
    packageName
    redistName
    version
    ;
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets)
    filterAttrs
    mapAttrs
    mapAttrs'
    optionalAttrs
    removeAttrs
    ;
  inherit (lib.customisation) makeOverridable;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.licenses) nvidiaCudaRedist;
  inherit (lib.lists)
    elem
    findFirst
    reverseList
    take
    ;
  inherit (lib.options) mkOption;
  inherit (lib.strings)
    concatStringsSep
    hasPrefix
    replaceStrings
    versionAtLeast
    versionOlder
    ;
  inherit (lib.trivial)
    const
    flip
    functionArgs
    mapNullable
    pipe
    setFunctionArgs
    ;
  inherit (lib.types)
    bool
    enum
    functionTo
    lazyAttrsOf
    nonEmptyListOf
    nonEmptyStr
    nullOr
    package
    raw
    ;
  inherit (lib.versions) major majorMinor splitVersion;
  inherit (pkgs) fetchurl srcOnly;
in
{
  options.utils = mapAttrs (const mkOption) {
    assertMsgOutputIsPresent = {
      description = ''
        Helper function which provides a message for `assert` when a package is missing an output.
      '';
      type = functionTo (functionTo (functionTo bool));
      default =
        name: output: pkg:
        assertMsg (elem output pkg.outputs) "${name}: ${pkg.name} is missing output ${output}";
    };
    buildRedistPackage = {
      description = ''
        Helper function which wraps the manifest builder to build a redistributable package.
        Expects the fixed-point (`final`), and a flattenedIndexElem.
      '';
      type = functionTo (functionTo package);
      default =
        let
          manifestBuilderFn = builtins.import ./manifest-builder;
          manifestBuilderFnArgs = functionArgs manifestBuilderFn;
        in
        final:
        flattenedIndexElem@{
          packageName,
          redistName,
          releaseInfo,
          packageInfo,
          version,
          ...
        }:
        let
          overrideAttrsFnFn = config.utils.overrideAttrsFnFns.${redistName}.${packageName} or null;
          overrideAttrsFnFnArgs = if overrideAttrsFnFn != null then functionArgs overrideAttrsFnFn else { };

          manifestBuilderArgs = {
            inherit (flattenedIndexElem) packageInfo packageName releaseInfo;
            libPath = config.utils.getLibPath final.cudaMajorMinorPatchVersion packageInfo.feature.cudaVersionsInLib;
            # The source is given by the tarball, which we unpack and use as a FOD.
            src =
              let
                tarball = fetchurl {
                  inherit (packageInfo) sha256;
                  url =
                    if redistName == "tensorrt" then
                      config.utils.mkTensorRTURL packageInfo.relativePath
                    else
                      config.utils.mkRedistURL redistName (
                        config.utils.mkRelativePath (
                          flattenedIndexElem // { inherit (flattenedIndexElem.packageInfo) relativePath; }
                        )
                      );
                };
                unpacked = srcOnly {
                  __structuredAttrs = true;
                  strictDeps = true;
                  name = tarball.name + "-unpacked";
                  src = tarball;
                  outputHashMode = "recursive";
                  outputHash = packageInfo.narHash;
                };
              in
              unpacked;
          };

          # Union of all arguments provided to the manifest builder function and the function which produces arguments
          # to provide to overrideAttrs.
          # Get the arguments from callPackage and remove the override arguments.
          allRequestedArgs = manifestBuilderFnArgs // overrideAttrsFnFnArgs;
          package = pipe allRequestedArgs [
            # Create a function which returns its argument -- but make it expect all the arguments we need!
            (setFunctionArgs (pkgs: pkgs))
            # Call our newly minted function with callPackage to get all the arguments we need.
            (flip final.callPackage manifestBuilderArgs)
            # Remove the callPackage-provided attributes.
            (flip removeAttrs [
              "override"
              "overrideDerivation"
            ])
            # Build the package, applying overrides if they exist, and provide a new override to handle the
            # split-overrides coming from both the manifest builder and the overrideAttrs function.
            (makeOverridable (
              providedArgs:
              let
                # Get the arguments we'll need to provide to our mainfest builder and overrideAttrs-producing function.
                providedManifestBuilderFnArgs = builtins.intersectAttrs manifestBuilderFnArgs providedArgs;
                providedOverrideAttrsFnFnArgs = builtins.intersectAttrs overrideAttrsFnFnArgs providedArgs;
                # Update the package license before applying the overrideAttrs function.
                pkg = (manifestBuilderFn providedManifestBuilderFnArgs).overrideAttrs (prevAttrs: {
                  meta = prevAttrs.meta // {
                    license = nvidiaCudaRedist // {
                      url =
                        let
                          licensePath =
                            if releaseInfo.licensePath != null then releaseInfo.licensePath else "${packageName}/LICENSE.txt";
                        in
                        "https://developer.download.nvidia.com/compute/${redistName}/redist/${licensePath}";
                    };
                  };
                });
              in
              if overrideAttrsFnFn != null then
                pkg.overrideAttrs (overrideAttrsFnFn providedOverrideAttrsFnFnArgs)
              else
                pkg
            ))
          ];
        in
        package;
    };
    getLibPath = {
      description = ''
        Returns the path to the CUDA library directory for a given version or null if no such version exists.
      '';
      type = functionTo (functionTo (nullOr version));
      # fullCudaVersion :: Version -> cudaVersionsInLib :: null | NonEmptyList Version -> null | Version
      # Find the first libPath in the list of cudaVersionsInLib that is a prefix of the current cuda version.
      # "cudaVersionsInLib": [
      #   "10.2",
      #   "11",
      #   "11.0",
      #   "12"
      # ]
      # We sort the list of cudaVersionsInLib in reverse order so that we find the most specific match first (e.g.
      # "11.0" before "11").
      default =
        fullCudaVersion:
        mapNullable (
          flip pipe [
            reverseList
            (findFirst (flip hasPrefix (majorMinor fullCudaVersion)) null)
          ]
        );
    };
    getNixPlatforms = {
      description = ''
        Function to map NVIDIA redist arch to Nix platforms.

        NOTE: This function returns a list of platforms because the redistributable architecture `"source"` can be
        built on multiple platforms.

        NOTE: This function *will* be called by unsupported platforms because `cudaPackages` is part of
        `all-packages.nix`, which is evaluated on all platforms. As such, we need to handle unsupported
        platforms gracefully.
      '';
      type = functionTo (nonEmptyListOf nonEmptyStr);
      default =
        let
          platformMapping = {
            linux-sbsa = [ "aarch64-linux" ];
            linux-aarch64 = [ "aarch64-linux" ];
            linux-x86_64 = [ "x86_64-linux" ];
            linux-ppc64le = [ "powerpc64le-linux" ];
            windows-x86_64 = [ "x86_64-windows" ];
            source = [
              "aarch64-linux" # Both SBSA (ARM servers) and Jetson
              "powerpc64le-linux" # POWER
              "x86_64-linux" # x86_64
              "x86_64-windows" # Windows
            ];
          };
        in
        redistArch: platformMapping.${redistArch} or [ "unsupported" ];
    };
    getRedistArch = {
      description = ''
        Function to map Nix system to NVIDIA redist arch

        NOTE: We swap out the default `linux-sbsa` redist (for server-grade ARM chips) with the
        `linux-aarch64` redist (which is for Jetson devices) if we're building any Jetson devices.
        Since both are based on aarch64, we can only have one or the other, otherwise there's an
        ambiguity as to which should be used.

        NOTE: This function *will* be called by unsupported systems because `cudaPackages` is part of
        `all-packages.nix`, which is evaluated on all systems. As such, we need to handle unsupported
        systems gracefully.
      '';
      type = functionTo (enum [
        "linux-aarch64"
        "linux-ppc64le"
        "linux-sbsa"
        "linux-x86_64"
        "unsupported"
        "windows-x86_64"
      ]);
      default =
        let
          platformMapping = {
            aarch64-linux = if config.data.jetsonTargets != [ ] then "linux-aarch64" else "linux-sbsa";
            x86_64-linux = "linux-x86_64";
            ppc64le-linux = "linux-powerpc64le";
            x86_64-windows = "windows-x86_64";
          };
        in
        nixSystem: platformMapping.${nixSystem} or "unsupported";
    };
    majorMinorPatch = {
      description = "Function to extract the major, minor, and patch version from a string";
      type = functionTo version;
      default = flip pipe [
        splitVersion
        (take 3)
        (concatStringsSep ".")
      ];
    };
    mkCudaVariant = {
      description = "Function to generate a CUDA variant name from a version";
      type = functionTo cudaVariant;
      default = version: "cuda${major version}";
    };
    mkFilteredIndex = {
      description = ''
        Generates a filtered indexOf packageInfo given a cudaMajorMinorPatchVersion.
      '';
      type = functionTo (functionTo (indexOf packageInfo));
      default =
        cudaMajorMinorPatchVersion: packageInfoIndex:
        # NOTE: Here's what's happening with this particular mess of code:
        #       Working from the inside out, at each level we're filter the attribute set, removing packages which
        #       won't work with the current CUDA version.
        #       One level up, we're using mapAttrs to set the values of the attribute set equal to the newly filtered
        #       attribute set. We then pass this newly mapAttrs-ed attribute set to filterAttrs again, removing any
        #       empty attribute sets.
        filterAttrs (redistName: redistNameMapping: { } != redistNameMapping) (
          mapAttrs (
            redistName: redistNameMapping:
            filterAttrs (version: versionMapping: { } != versionMapping) (
              mapAttrs (
                version: versionMapping:
                filterAttrs (packageName: packageNameMapping: { } != packageNameMapping.packages) (
                  mapAttrs (packageName: packageNameMapping: {
                    inherit (packageNameMapping) releaseInfo;
                    packages = filterAttrs (platform: cudaVariantMapping: { } != cudaVariantMapping) (
                      mapAttrs (
                        platform: cudaVariantMapping:
                        filterAttrs (
                          cudaVariant: packageInfo:
                          config.utils.packageSatisfiesRedistRequirements cudaMajorMinorPatchVersion {
                            inherit
                              cudaVariant
                              packageInfo
                              packageName
                              platform
                              redistName
                              version
                              ;
                            inherit (packageNameMapping) releaseInfo;
                          }
                        ) cudaVariantMapping
                      ) packageNameMapping.packages
                    );
                  }) versionMapping
                )
              ) redistNameMapping
            )
          ) packageInfoIndex
        );
    };
    mkFlattenedIndex = {
      description = "Function to flatten an index of packageInfo into a list of attribute sets";
      type = functionTo (nonEmptyListOf flattenedIndexElem);
      default = config.utils.mapIndexLeavesToList (
        args@{
          cudaVariant,
          leaf,
          packageName,
          platform,
          redistName,
          releaseInfo,
          version,
        }:
        (builtins.removeAttrs args [ "leaf" ]) // { packageInfo = leaf; }
      );
    };
    mkMissingPackagesBadPlatformsConditions = {
      description = ''
        Utility function to generate a set of badPlatformsConditions for missing packages.

        Used to mark a package as unsupported if any of its required packages are missing (null).

        Expects a set of attributes.

        Most commonly used in overrides files on a callPackage-provided attribute set of packages.

        NOTE: We use badPlatformsConditions instead of brokenConditions because the presence of packages set to null
        means evaluation will fail if package attributes are accessed without checking for null first. OfBorg
        evaluation sets allowBroken to true, which means we can't rely on brokenConditions to prevent evaluation of
        a package with missing dependencies.
      '';
      type = functionTo (lazyAttrsOf bool);
      example = lib.options.literalExpression ''
        {
          lib,
          libcal ? null,
          libcublas ? null,
          utils,
        }:
        prevAttrs: {
          badPlatformsConditions =
            prevAttrs.badPlatformsConditions
            // utils.mkMissingPackagesBadPlatformsConditions { inherit libcal libcublas; };
        }
      '';
      default = flip pipe [
        # Take the attributes that are null.
        (filterAttrs (_: value: value == null))
        # Map them to a set of badPlatformsConditions.
        (mapAttrs' (
          name: value: {
            name = "Required package ${name} is missing";
            value = true;
          }
        ))
      ];
    };
    mkTrimmedIndex = {
      description = ''
        Helper function to reduce the number of attribute sets we need to traverse to create all the package sets.
        Since the CUDA redistributables make up the largest number of packages in the index, we can save time by
        flattening the portion of the index which does not contain CUDA redistributables, and reusing it for each
        version of CUDA.
        Additionally, we flatten only the CUDA redistributables for the version of CUDA we're currently processing.
      '';
      type = functionTo (functionTo (indexOf packageInfo));
      default =
        cudaMajorMinorPatchVersion: packageInfoIndex:
        let
          allButCudaIndex = removeAttrs packageInfoIndex [ "cuda" ];
          maybeCudaIndex = optionalAttrs (packageInfoIndex.cuda ? ${cudaMajorMinorPatchVersion}) {
            cuda.${cudaMajorMinorPatchVersion} = packageInfoIndex.cuda.${cudaMajorMinorPatchVersion};
          };
        in
        allButCudaIndex // maybeCudaIndex;
    };
    mkVersionedPackageName = {
      description = ''
        Function to generate a versioned package name.

        Expects a redistName, packageName, and version.

        NOTE: version should come from releaseInfo when taking arguments from a flattenedIndexElem, as the top-level
        version attribute is the version of the manifest.
      '';
      type = functionTo nonEmptyStr;
      default =
        {
          packageName,
          redistName,
          version,
        }:
        if redistName == "cuda" then
          # CUDA redistributables don't have versioned package names.
          packageName
        else
          # Everything else does.
          pipe version [
            # Take the major and minor version.
            majorMinor
            # Drop dots and replace them with underscores in the version.
            (replaceStrings [ "." ] [ "_" ])
            # Append the version to the package name.
            (version: "${packageName}_${version}")
          ];
    };
    overrideAttrsFnFns = {
      description = ''
        Attribute set of functions which are callPackage-able and provide arguments for a package's overrideAttrs. The
        attribute set is keyed by redistributable name and package name.

        These overrides contain the package-specific logic required to build or fixup a package constructed with the
        manifest builder.
      '';
      type =
        let
          # Unfortunately, checks cause the functions which produce arguments for overrideAttrs to be evaluated
          # strictly, breaking a number of things (manifesting as overrides being "called without required argument
          # 'lib'").
          # overrideAttrsFnType = oneOf [
          #   raw
          #   (functionTo raw)
          #   (functionTo (functionTo raw))
          # ];
          # overrideAttrsFnFnType = functionTo overrideAttrsFnType;
          overrideAttrsFnFnType = raw;
        in
        attrs redistName (
          attrs packageName (
            # One of:
            # {<callPackage args>}: prevAttrs: {<overrideAttrs>}
            # {<callPackage args>}: finalAttrs: prevAttrs: {<overrideAttrs>}
            overrideAttrsFnFnType
          )
        );
      default = packagesFromDirectoryRecursive {
        # Function which loads the file as a Nix expression and ignores the second argument.
        # NOTE: We don't actually want to callPackage these functions at this point, so we use builtins.import
        # instead. We do, however, have to match the callPackage signature.
        callPackage = path: _: builtins.import path;
        directory = ./overrides;
      };
    };
    packageSatisfiesRedistRequirements = {
      description = ''
        Function to determine if a package satisfies the redistributable requirements for a given redistributable.
        Expects a cudaMajorMinorPatchVersion and a flattenedIndexElem.
        Returns an attribute set of conditions, which when any are true, indicate the package does not satisfy a particular
        condition.
      '';
      type = functionTo (functionTo bool);
      default =
        cudaMajorMinorPatchVersion:
        {
          cudaVariant,
          packageInfo,
          platform,
          redistName,
          version,
          ...
        }:
        let
          inherit (packageInfo.feature) cudaVersionsInLib;

          # One of the subdirectories of the lib directory contains a supported version for our version of CUDA.
          # This is typically found with older versions of redistributables which don't use separate tarballs for each
          # supported CUDA version.
          hasSupportedCudaVersionInLib =
            (config.utils.getLibPath cudaMajorMinorPatchVersion cudaVersionsInLib) != null;

          # There is a variant for the desired CUDA version.
          isDesiredCudaVariant = cudaVariant == (config.utils.mkCudaVariant cudaMajorMinorPatchVersion);

          # Helpers
          cudaOlder = versionOlder cudaMajorMinorPatchVersion;
          cudaAtLeast = versionAtLeast cudaMajorMinorPatchVersion;

          # Default value for packages which don't specify some policy.
          default = isDesiredCudaVariant || hasSupportedCudaVersionInLib;
        in
        # Source packages are built on all platforms.
        # NOTE: Source packages are responsible for ensuring they depend on the correct version of their dependencies
        #       -- they may not be the default version available in the package set!
        if platform == "source" then
          true

        # CUBLASMP: Only packaged to support redistributables for CUDA 11.4 and later.
        # https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html
        else if redistName == "cublasmp" then
          cudaAtLeast "11.4" && isDesiredCudaVariant

        # CUDA: None of the CUDA redistributables have CUDA variants, but we only need to check that the release
        # version matches the CUDA version we want.
        else if redistName == "cuda" then
          version == cudaMajorMinorPatchVersion

        # CUDNN: Since cuDNN 8.5, it is possible to use the dynamic library for a CUDA release with any CUDA version
        # in that major release series. For example, the cuDNN 8.5 dynamic library for CUDA 11.0 can be used with
        # any CUDA 11.x release. (This functionality is not present for the CUDA 10.2 releases.)
        # As such, it is enough that the cuda variant matches to accept the package.
        else if redistName == "cudnn" then
          # CUDNN requires libcublasLt.so, which was introduced with CUDA 10.1, so we don't support CUDA 10.0.
          cudaAtLeast "10.1" && isDesiredCudaVariant

        # TODO: Create constraint.
        else if redistName == "cudss" then
          default

        # CUQUANTUM: Only available for CUDA 11.4 and later.
        else if redistName == "cuquantum" then
          # Releases prior to 23.03 are only compatible with CUDA 11 -- they look for libnames with
          # a .11 suffix.
          # They also don't provide CUDA versions in lib or cuda variants.
          if versionOlder version "23.03.0" then
            cudaAtLeast "11.4" && cudaOlder "12.0"

          # Releases including and after 23.03 provide CUDA versions in lib or cuda variants.
          else
            isDesiredCudaVariant || hasSupportedCudaVersionInLib

        # TODO: Create constraint.
        else if redistName == "cusolvermp" then
          default

        # CUSPARSELT:
        # Versions prior to 0.5.0 support CUDA 11.x (which we restrict to 11.4 and later).
        # Versions including and after 0.5.0 support only CUDA 12.0.
        # https://docs.nvidia.com/cuda/cusparselt/release_notes.html
        else if redistName == "cusparselt" then
          if versionAtLeast version "0.5.0" then
            cudaAtLeast "12.0"
          else
            cudaAtLeast "11.4" && cudaOlder "12.0"

        # CUTENSOR: Instead of providing CUDA variants, cuTensor provides multiple versions of the library nested
        # in the lib directory. So long as one of the versions in cudaVersionsInLib is a prefix of the current CUDA
        # version, we accept the package. We should have a more stringent version check, but no one has written
        # a sidecar file mapping releases to supported CUDA versions.
        else if redistName == "cutensor" then
          hasSupportedCudaVersionInLib

        # TODO: Create constraint.
        else if redistName == "nvidia-driver" then
          default

        # TODO: Create constraint.
        else if redistName == "nvjpeg2000" then
          default

        # TODO: Create constraint.
        else if redistName == "nvpl" then
          default

        # TODO: Create constraint.
        else if redistName == "nvtiff" then
          default

        # TODO: Create constraint.
        else if redistName == "tensorrt" then
          default

        # NOTE: We must be total.
        else
          builtins.throw "Unsupported NVIDIA redistributable: ${redistName}";
    };
  };
}
