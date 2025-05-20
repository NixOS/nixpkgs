{
  lib,
  cudaLib,
  cudaMajorMinorVersion,
  redistSystem,
  stdenv,
  # Builder-specific arguments
  # Short package name (e.g., "cuda_cccl")
  # pname : String
  pname,
  # Common name (e.g., "cutensor" or "cudnn") -- used in the URL.
  # Also known as the Redistributable Name.
  # redistName : String,
  redistName,
  # releasesModule :: Path
  # A path to a module which provides a `releases` attribute
  releasesModule,
  # shims :: Path
  # A path to a module which provides a `shims` attribute
  # The redistribRelease is only used in ./manifest.nix for the package version
  # and the package description (which NVIDIA's manifest calls the "name").
  # It's also used for fetching the source, but we override that since we can't
  # re-use that portion of the functionality (different URLs, etc.).
  # The featureRelease is used to populate meta.platforms (by way of looking at the attribute names), determine the
  # outputs of the package, and provide additional package-specific constraints (e.g., min/max supported CUDA versions,
  # required versions of other packages, etc.).
  # shimFn :: {package, redistSystem} -> AttrSet
  shimsFn ? (throw "shimsFn must be provided"),
}:
let
  evaluatedModules = lib.modules.evalModules {
    modules = [
      ../modules
      releasesModule
    ];
  };

  # NOTE: Important types:
  # - Releases: ../modules/${pname}/releases/releases.nix
  # - Package: ../modules/${pname}/releases/package.nix

  # Check whether a package supports our CUDA version.
  # satisfiesCudaVersion :: Package -> Bool
  satisfiesCudaVersion =
    package:
    lib.versionAtLeast cudaMajorMinorVersion package.minCudaVersion
    && lib.versionAtLeast package.maxCudaVersion cudaMajorMinorVersion;

  # FIXME: do this at the module system level
  propagatePlatforms = lib.mapAttrs (redistSystem: lib.map (p: { inherit redistSystem; } // p));

  # Releases for all platforms and all CUDA versions.
  allReleases = propagatePlatforms evaluatedModules.config.${pname}.releases;

  # Releases for all platforms and our CUDA version.
  allReleases' = lib.mapAttrs (_: lib.filter satisfiesCudaVersion) allReleases;

  # Packages for all platforms and our CUDA versions.
  allPackages = lib.concatLists (lib.attrValues allReleases');

  packageOlder = p1: p2: lib.versionOlder p1.version p2.version;
  packageSupportedPlatform = p: p.redistSystem == redistSystem;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: Package -> String
  computeName = { version, ... }: cudaLib.mkVersionedName pname (lib.versions.majorMinor version);

  # The newest package for each major-minor version, with newest first.
  # newestPackages :: List Package
  newestPackages =
    let
      newestForEachMajorMinorVersion = lib.foldl' (
        newestPackages: package:
        let
          majorMinorVersion = lib.versions.majorMinor package.version;
          existingPackage = newestPackages.${majorMinorVersion} or null;
        in
        newestPackages
        // {
          ${majorMinorVersion} =
            # Only keep the existing package if it is newer than the one we are considering or it is supported on the
            # current platform and the one we are considering is not.
            if
              existingPackage != null
              && (
                packageOlder package existingPackage
                || (!packageSupportedPlatform package && packageSupportedPlatform existingPackage)
              )
            then
              existingPackage
            else
              package;
        }
      ) { } allPackages;
    in
    # Sort the packages by version so the newest is first.
    # NOTE: builtins.sort requires a strict weak ordering, so we must use versionOlder rather than versionAtLeast.
    # See https://github.com/NixOS/nixpkgs/commit/9fd753ea84e5035b357a275324e7fd7ccfb1fc77.
    lib.sort (lib.flip packageOlder) (lib.attrValues newestForEachMajorMinorVersion);

  extension =
    final: _:
    let
      # Builds our package into derivation and wraps it in a nameValuePair, where the name is the versioned name
      # of the package.
      buildPackage =
        package:
        let
          shims = final.callPackage shimsFn { inherit package redistSystem; };
          name = computeName package;
          drv = final.callPackage ./manifest.nix {
            inherit pname redistName;
            inherit (shims) redistribRelease featureRelease;
          };
        in
        lib.nameValuePair name drv;

      # versionedDerivations :: AttrSet Derivation
      versionedDerivations = builtins.listToAttrs (lib.map buildPackage newestPackages);

      defaultDerivation = {
        ${pname} = (buildPackage (lib.head newestPackages)).value;
      };
    in
    # NOTE: Must condition on the length of newestPackages to avoid non-total function lib.head aborting if
    # newestPackages is empty.
    lib.optionalAttrs (lib.length newestPackages > 0) (versionedDerivations // defaultDerivation);
in
extension
