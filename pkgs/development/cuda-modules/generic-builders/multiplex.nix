{
  # callPackage-provided arguments
  lib,
  cudaVersion,
  flags,
  hostPlatform,
  # Expected to be passed by the caller
  mkVersionedPackageName,
  # pname :: String
  pname,
  # releasesModule :: Path
  # A path to a module which provides a `releases` attribute
  releasesModule,
  # shims :: Path
  # A path to a module which provides a `shims` attribute
  # The redistribRelease is only used in ./manifest.nix for the package version
  # and the package description (which NVIDIA's manifest calls the "name").
  # It's also used for fetching the source, but we override that since we can't
  # re-use that portion of the functionality (different URLs, etc.).
  # The featureRelease is used to populate meta.platforms (by way of looking at the attribute names)
  # and to determine the outputs of the package.
  # shimFn :: {package, redistArch} -> AttrSet
  shimsFn ? ({package, redistArch}: throw "shimsFn must be provided"),
  # fixupFn :: Path
  # A path (or nix expression) to be evaluated with callPackage and then
  # provided to the package's overrideAttrs function.
  # It must accept at least the following arguments:
  # - final
  # - cudaVersion
  # - mkVersionedPackageName
  # - package
  fixupFn ? (
    {
      final,
      cudaVersion,
      mkVersionedPackageName,
      package,
      ...
    }:
    throw "fixupFn must be provided"
  ),
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    strings
    ;

  evaluatedModules = modules.evalModules {
    modules = [
      ../modules
      releasesModule
    ];
  };

  # NOTE: Important types:
  # - Releases: ../modules/${pname}/releases/releases.nix
  # - Package: ../modules/${pname}/releases/package.nix

  # All releases across all platforms
  # See ../modules/${pname}/releases/releases.nix
  allReleases = evaluatedModules.config.${pname}.releases;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: Package -> String
  computeName = {version, ...}: mkVersionedPackageName pname version;

  # Check whether a package supports our CUDA version
  # isSupported :: Package -> Bool
  isSupported =
    package:
    strings.versionAtLeast cudaVersion package.minCudaVersion
    && strings.versionAtLeast package.maxCudaVersion cudaVersion;

  # Get all of the packages for our given platform.
  redistArch = flags.getRedistArch hostPlatform.system;

  # All the supported packages we can build for our platform.
  # supportedPackages :: List (AttrSet Packages)
  supportedPackages = builtins.filter isSupported (allReleases.${redistArch} or []);

  # newestToOldestSupportedPackage :: List (AttrSet Packages)
  newestToOldestSupportedPackage = lists.reverseList supportedPackages;

  nameOfNewest = computeName (builtins.head newestToOldestSupportedPackage);

  # A function which takes the `final` overlay and the `package` being built and returns
  # a function to be consumed via `overrideAttrs`.
  overrideAttrsFixupFn =
    final: package:
    final.callPackage fixupFn {
      inherit
        final
        cudaVersion
        mkVersionedPackageName
        package
        ;
    };

  extension =
    final: _:
    let
      # Builds our package into derivation and wraps it in a nameValuePair, where the name is the versioned name
      # of the package.
      buildPackage =
        package:
        let
          shims = final.callPackage shimsFn {inherit package redistArch;};
          name = computeName package;
          drv = final.callPackage ./manifest.nix {
            inherit pname;
            redistName = pname;
            inherit (shims) redistribRelease featureRelease;
          };
          fixedDrv = drv.overrideAttrs (overrideAttrsFixupFn final package);
        in
        attrsets.nameValuePair name fixedDrv;

      # versionedDerivations :: AttrSet Derivation
      versionedDerivations = builtins.listToAttrs (lists.map buildPackage newestToOldestSupportedPackage);

      defaultDerivation = attrsets.optionalAttrs (versionedDerivations != {}) {
        ${pname} = versionedDerivations.${nameOfNewest};
      };
    in
    versionedDerivations // defaultDerivation;
in
extension
