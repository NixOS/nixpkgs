{
  lib,
  callPackage,
  stdenv,
  stdenvAdapters,
  gccVersions ? { },
  patchesFn ? lib.id,
  buildPackages,
  targetPackages,
  binutilsNoLibc,
  binutils,
  generateSplicesForMkScope,
  ...
}@packageSetArgs:
let
  versions = {
    "15.1.0".officialRelease.sha256 = "sha256-4rCewhZg8B/s/7cV4BICZSFpQ/A40OSKmGhxPlTwbOo=";
  }
  // gccVersions;

  mkPackage =
    {
      name ? null,
      officialRelease ? null,
      gitRelease ? null,
      monorepoSrc ? null,
      version ? null,
    }@args:
    let
      inherit
        (import ./common/common-let.nix {
          inherit
            lib
            gitRelease
            officialRelease
            version
            ;
        })
        releaseInfo
        ;
      inherit (releaseInfo) release_version;
      attrName =
        args.name or (if (gitRelease != null) then "git" else lib.versions.major release_version);
    in
    lib.nameValuePair attrName (
      lib.recurseIntoAttrs (
        callPackage ./common (
          {
            inherit (stdenvAdapters) overrideCC;
            inherit
              officialRelease
              gitRelease
              monorepoSrc
              version
              patchesFn
              ;

            buildGccPackages = buildPackages."gccNGPackages_${attrName}";
            targetGccPackages = targetPackages."gccNGPackages_${attrName}" or gccPackages."${attrName}";
            otherSplices = generateSplicesForMkScope "gccNGPackages_${attrName}";
          }
          // packageSetArgs # Allow overrides.
        )
      )
    );

  gccPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
gccPackages // { inherit mkPackage; }
