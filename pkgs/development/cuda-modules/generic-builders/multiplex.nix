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
  shimsFn ? (throw "shimsFn must be provided"),
  # fixupFn :: Path
  # A path (or nix expression) to be evaluated with callPackage and then
  # provided to the package's overrideAttrs function.
  # It must accept at least the following arguments:
  # - final
  # - cudaVersion
  # - mkVersionedPackageName
  # - package
  # - ...
  fixupFn ? (throw "fixupFn must be provided"),
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

  # FIXME: do this at the module system level
  propagatePlatforms = lib.mapAttrs (
    redistArch: packages: map (p: { inherit redistArch; } // p) packages
  );

  # All releases across all platforms
  # See ../modules/${pname}/releases/releases.nix
  releaseSets = propagatePlatforms evaluatedModules.config.${pname}.releases;

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: Package -> String
  computeName = { version, ... }: mkVersionedPackageName pname version;

  # Check whether a package supports our CUDA version and platform.
  # isSupported :: Package -> Bool
  isSupported =
    package:
    redistArch == package.redistArch
    && strings.versionAtLeast cudaVersion package.minCudaVersion
    && strings.versionAtLeast package.maxCudaVersion cudaVersion;

  # Get all of the packages for our given platform.
  # redistArch :: String
  # Value is `"unsupported"` if the platform is not supported.
  redistArch = flags.getRedistArch hostPlatform.system;

  preferable =
    p1: p2: (isSupported p2 -> isSupported p1) && (strings.versionAtLeast p1.version p2.version);

  # All the supported packages we can build for our platform.
  # perSystemReleases :: List Package
  allReleases = lib.pipe releaseSets [
    (lib.attrValues)
    (lists.flatten)
    (lib.groupBy (p: lib.versions.majorMinor p.version))
    (lib.mapAttrs (_: builtins.sort preferable))
    (lib.mapAttrs (_: lib.take 1))
    (lib.attrValues)
    (lib.concatMap lib.trivial.id)
  ];

  newest = builtins.head (builtins.sort preferable allReleases);

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
          shims = final.callPackage shimsFn {
            inherit package;
            inherit (package) redistArch;
          };
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
      versionedDerivations = builtins.listToAttrs (lists.map buildPackage allReleases);

      defaultDerivation = {
        ${pname} = (buildPackage newest).value;
      };
    in
    versionedDerivations // defaultDerivation;
in
extension
