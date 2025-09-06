{
  _cuda,
  config,
  lib,
  pkgs,
  stdenv,
  # Manually provided arguments
  manifests,
}:
let
  inherit (lib.attrsets)
    concatMapAttrs
    listToAttrs
    mapCartesianProduct
    optionalAttrs
    ;
  inherit (lib.customisation) callPackagesWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.fixedPoints) composeManyExtensions extends;
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep versionAtLeast versionOlder;
  inherit (lib.trivial) importJSON;
  inherit (lib.versions) major majorMinor;
  inherit (_cuda.lib)
    dropDots
    formatCapabilities
    mkVersionedName
    ;

  # NOTE: This value is considered an implementation detail and should not be exposed in the attribute set.
  cudaMajorMinorPatchVersion = manifests.cuda.release_label;
  cudaMajorMinorVersion = majorMinor cudaMajorMinorPatchVersion;
  cudaMajorVersion = major cudaMajorMinorPatchVersion;

  cudaPackagesMajorMinorVersionedName = mkVersionedName "cudaPackages" cudaMajorMinorVersion;

  # We must use an instance of Nixpkgs where the CUDA package set we're building is the default; if we do not, members
  # of the versioned, non-default package sets may rely on (transitively) members of the default, unversioned CUDA
  # package set.
  # See `Using cudaPackages.pkgs` in doc/languages-frameworks/cuda.section.md for more information.
  pkgs' =
    let
      cudaPackagesUnversionedName = "cudaPackages";
      cudaPackagesMajorVersionedName = mkVersionedName cudaPackagesUnversionedName cudaMajorVersion;
    in
    pkgs.extend (
      final: _: {
        recurseForDerivations = false;
        # The CUDA package set will be available as cudaPackages_x_y, so we need only update the aliases for the
        # minor-versioned and unversioned package sets.
        # cudaPackages_x = cudaPackages_x_y
        ${cudaPackagesMajorVersionedName} = final.${cudaPackagesMajorMinorVersionedName};
        # cudaPackages = cudaPackages_x
        ${cudaPackagesUnversionedName} = final.${cudaPackagesMajorVersionedName};
      }
    );

  cudaPackagesFixedPoint =
    finalCudaPackages:
    {
      # NOTE:
      # It is important that _cuda is not part of the package set fixed-point. As described by
      # @SomeoneSerge:
      # > The layering should be: configuration -> (identifies/is part of) cudaPackages -> (is built using) cudaLib.
      # > No arrows should point in the reverse directions.
      # That is to say that cudaLib should only know about package sets and configurations, because it implements
      # functionality for interpreting configurations, resolving them against data, and constructing package sets.
      # This decision is driven both by a separation of concerns and by "NAMESET STRICTNESS" (see above).
      # Also see the comment in `pkgs/top-level/all-packages.nix` about the `_cuda` attribute.

      inherit
        cudaMajorMinorPatchVersion
        cudaMajorMinorVersion
        cudaMajorVersion
        ;

      pkgs = pkgs';

      # Core
      callPackages = callPackagesWith (pkgs' // finalCudaPackages);

      cudaNamePrefix = "cuda${cudaMajorMinorVersion}";

      cudaOlder = versionOlder cudaMajorMinorVersion;
      cudaAtLeast = versionAtLeast cudaMajorMinorVersion;

      # These must be modified through callPackage, not by overriding the scope, since we cannot
      # depend on them recursively as they are used to add top-level attributes.
      inherit manifests;

      # Must be constructed without `callPackage` to avoid replacing the `override` attribute with that of
      # `callPackage`'s.
      buildRedist = import ./buildRedist {
        inherit (pkgs)
          _cuda
          autoAddDriverRunpath
          autoPatchelfHook
          config
          fetchurl
          lib
          srcOnly
          stdenv
          stdenvNoCC
          ;
        inherit (finalCudaPackages)
          autoAddCudaCompatRunpath
          backendStdenv
          cudaMajorMinorVersion
          cudaMajorVersion
          cudaNamePrefix
          flags
          manifests
          markForCudatoolkitRootHook
          setupCudaHook
          ;
      };

      unpackedRedistPackages = pkgs'.linkFarm "unpackedRedistPackages" (
        concatMapAttrs (
          name: drv:
          optionalAttrs (drv.src != null && drv.passthru ? redistName) {
            ${name} = drv.src;
          }
        ) finalCudaPackages
      );

      flags =
        formatCapabilities {
          inherit (finalCudaPackages.backendStdenv) cudaCapabilities cudaForwardCompat;
          inherit (_cuda.db) cudaCapabilityToInfo;
        }
        # TODO(@connorbaker): Enable the corresponding warnings in `./aliases.nix` after some
        # time to allow users to migrate to cudaLib and backendStdenv.
        // {
          inherit dropDots;
          cudaComputeCapabilityToName =
            cudaCapability: _cuda.db.cudaCapabilityToInfo.${cudaCapability}.archName;
          dropDot = dropDots;
          isJetsonBuild = finalCudaPackages.backendStdenv.hasJetsonCudaCapability;
        };

      # Loose packages
      # Barring packages which share a home (e.g., cudatoolkit), new packages
      # should be added to ./packages in "by-name" style, where they will be automatically
      # discovered and added to the package set.

      # Prevent missing attribute errors
      # NOTE(@connorbaker): CUDA 12.3 does not have a cuda_compat package; indeed, none of the release supports
      # Jetson devices. To avoid errors in the case that cuda_compat is not defined, we have a dummy package which
      # is always defined, but does nothing, will not build successfully, and has no platforms.
      cuda_compat = pkgs'.runCommand "cuda_compat" {
        meta = {
          broken = true;
          platforms = [ ];
        };
      } "false";

      # Alternative versions of select packages.
      # This should be minimized as much as possible.
      cudnn_8_9 = finalCudaPackages.cudnn.overrideAttrs (prevAttrs: {
        passthru = prevAttrs.passthru // {
          release =
            let
              manifest =
                if finalCudaPackages.backendStdenv.hasJetsonCudaCapability then
                  ./_cuda/manifests/cudnn/redistrib_8.9.5.json
                else
                  ./_cuda/manifests/cudnn/redistrib_8.9.7.json;
            in
            (importJSON manifest).cudnn;
        };
      });

      tests =
        let
          bools = [
            true
            false
          ];
          configs = {
            openCVFirst = bools;
            useOpenCVDefaultCuda = bools;
            useTorchDefaultCuda = bools;
          };
          builder =
            {
              openCVFirst,
              useOpenCVDefaultCuda,
              useTorchDefaultCuda,
            }@config:
            {
              name = concatStringsSep "-" (
                [
                  "test"
                  (if openCVFirst then "opencv" else "torch")
                ]
                ++ optionals (if openCVFirst then useOpenCVDefaultCuda else useTorchDefaultCuda) [
                  "with-default-cuda"
                ]
                ++ [
                  "then"
                  (if openCVFirst then "torch" else "opencv")
                ]
                ++ optionals (if openCVFirst then useTorchDefaultCuda else useOpenCVDefaultCuda) [
                  "with-default-cuda"
                ]
              );
              value = finalCudaPackages.callPackage ./tests/opencv-and-torch config;
            };
        in
        listToAttrs (mapCartesianProduct builder configs)
        // {
          flags = finalCudaPackages.callPackage ./tests/flags.nix { };
        };
    }
    # CUDA version-specific packages
    // packagesFromDirectoryRecursive {
      inherit (finalCudaPackages) callPackage;
      directory = ./packages;
    };

  composedExtensions = composeManyExtensions (
    [
      # TODO: cudnn
      # TODO: cutensor
      # TODO: libcusparse_lt for various releases
      # TODO: tensorrt
      (import ./cuda-library-samples/extension.nix { inherit lib stdenv; })
    ]
    ++ optionals config.allowAliases [
      (import ./aliases.nix { inherit lib; })
    ]
    ++ _cuda.extensions
  );
in
pkgs'.makeScopeWithSplicing' {
  otherSplices = pkgs'.generateSplicesForMkScope [ cudaPackagesMajorMinorVersionedName ];
  f = extends composedExtensions cudaPackagesFixedPoint;
}
