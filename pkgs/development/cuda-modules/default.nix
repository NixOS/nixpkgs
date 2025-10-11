{
  _cuda,
  config,
  lib,
  pkgs,
  # Manually provided arguments
  manifests,
}:
let
  inherit (lib.customisation) callPackagesWith;
  inherit (lib.filesystem) packagesFromDirectoryRecursive;
  inherit (lib.fixedPoints) composeManyExtensions extends;
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionAtLeast versionOlder;
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

      # Create backendStdenv variants for different host compilers, since users may want to build a CUDA project with
      # Clang or GCC specifically.
      # TODO(@connorbaker): Because of the way our setup hooks and patching of NVCC works, the user's choice of
      # backendStdenv is largely disregarded or will cause build failures; fixing this would require the setup hooks
      # and patching to be made aware of the current environment (perhaps by reading certain environment variables set
      # by our backendStdenv).
      # backendClangStdenv = finalCudaPackages.callPackage ./packages/backendStdenv.nix {
      #   stdenv = pkgs'.clangStdenv;
      # };
      # backendGccStdenv = finalCudaPackages.callPackage ./packages/backendStdenv.nix {
      #   stdenv = pkgs'.gccStdenv;
      # };

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
    }
    // packagesFromDirectoryRecursive {
      inherit (finalCudaPackages) callPackage;
      directory = ./packages;
    };

  composedExtensions = composeManyExtensions (
    optionals config.allowAliases [
      (import ./aliases.nix { inherit lib; })
    ]
    ++ _cuda.extensions
  );
in
pkgs'.makeScopeWithSplicing' {
  otherSplices = pkgs'.generateSplicesForMkScope [ cudaPackagesMajorMinorVersionedName ];
  f = extends composedExtensions cudaPackagesFixedPoint;
}
