{
  # callPackage-provided arguments
  lib,
  cudaVersion,
  flags,
  stdenv,
  # Expected to be passed by the caller
  mkVersionedPackageName,
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
  # shimFn :: {package, redistArch} -> AttrSet
  shimsFn ? (throw "shimsFn must be provided"),
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    strings
    ;

  inherit (stdenv) hostPlatform;

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
    p1: p2: (isSupported p2 -> isSupported p1) && (strings.versionOlder p2.version p1.version);

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
            inherit pname redistName;
            inherit (shims) redistribRelease featureRelease;
          };
        in
        attrsets.nameValuePair name drv;

      # versionedDerivations :: AttrSet Derivation
      versionedDerivations = builtins.listToAttrs (lists.map buildPackage allReleases);

      defaultDerivation = {
        ${pname} = (buildPackage newest).value;
      };
    in
    versionedDerivations // defaultDerivation;
in
extension
