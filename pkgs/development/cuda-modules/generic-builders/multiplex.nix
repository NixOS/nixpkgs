{
  # callPackage-provided arguments
  callPackage,
  lib,
  cudaVersion,
  flags,
  hostPlatform,
  # Expected to be passed by the caller
  mkVersionedPackageName,
  # pname :: String
  pname,
  config,
}:
let
  inherit (lib)
    attrsets
    lists
    modules
    strings
    ;
  cfg = config.${pname};

  # NOTE: Important types:
  # - Releases: ../modules/${pname}/releases/releases.nix
  # - Package: ../modules/${pname}/releases/package.nix

  # Compute versioned attribute name to be used in this package set
  # Patch version changes should not break the build, so we only use major and minor
  # computeName :: Package -> String
  computeName = { version, ... }: mkVersionedPackageName pname version;

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
  supportedPackages =
    if redistArch == null then [ ] else builtins.filter isSupported (cfg.releases.${redistArch} or [ ]);

  # newestToOldestSupportedPackage :: List (AttrSet Packages)
  newestToOldestSupportedPackage = lists.reverseList supportedPackages;

  nameOfNewest = computeName (builtins.head newestToOldestSupportedPackage);

  # A function which takes the `final` overlay and the `package` being built and returns
  # a function to be consumed via `overrideAttrs`.
  overrideAttrsFixupFn =
    package: callPackage cfg.fixupFnPath { inherit cudaVersion mkVersionedPackageName package; };

  # Builds our package into derivation and wraps it in a nameValuePair, where the name is the versioned name
  # of the package.
  buildPackage =
    package:
    let
      manifests = callPackage cfg.shimsFnPath { inherit package redistArch; };
      name = computeName package;
      drv = callPackage ./manifest.nix {
        inherit pname manifests;
        redistName = pname;
      };
      fixedDrv = drv.overrideAttrs (overrideAttrsFixupFn package);
    in
    attrsets.nameValuePair name fixedDrv;

  # versionedDerivations :: AttrSet Derivation
  versionedDerivations = builtins.listToAttrs (lists.map buildPackage newestToOldestSupportedPackage);

  defaultDerivation = attrsets.optionalAttrs (versionedDerivations != { }) {
    ${pname} = versionedDerivations.${nameOfNewest};
  };
in
versionedDerivations // defaultDerivation
