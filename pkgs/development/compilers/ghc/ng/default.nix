# Version table for the split GHC package sets.
#
# Mirrors `gcc/ng/default.nix`: a table of versions, a `mkPackage` that turns one
# table entry into a set, and `ghcVersions` / `packageSetArgs` escape hatches so
# a caller can add or override a version without editing this file.
{
  lib,
  callPackage,
  ghcVersions ? { },
  ...
}@packageSetArgs:
let
  versions = {
    "9.14.1".officialRelease.sha256 =
      "2a83779c9af86554a3289f2787a38d6aa83d00d136aa9f920361dd693c101e77";
    # A release ships the testsuite as its own tarball; `-src.tar.xz` has no
    # `testsuite/` directory at all. A git checkout carries it inline, so
    # `gitRelease` entries need nothing here.
    "9.14.1".officialRelease.testsuiteSha256 =
      "1va5ls4ng32hq8236w2aq5k0gjwxzdmwgfjf6b8z7pgpy0hzrbl4";

    "9.15".setupCabalVersion = "3_16_1_0";
    "9.15".gitRelease = {
      version = "9.15.20260322";
      date = "2026-03-22";
      rev = "44f118f09dcde49f64d03e427312df4732f2d4a4";
      sha256 = "sha256-xby7HKyK5P1Y5DjKbVe62piDCY4Ujb4pbv8AJ7sQ0HI=";
    };
  }
  // ghcVersions;

  mkPackage =
    {
      name ? null,
      officialRelease ? null,
      gitRelease ? null,
      version ? null,
      setupCabalVersion ? "3_12_1_0",
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
      # `9.14`, or `head` for an in-development snapshot. Underscored elsewhere
      # (`ghcNG_9_14`) because attribute paths in `pkgs` may not contain dots.
      attrName =
        args.name or (
          if gitRelease != null then "head" else lib.versions.majorMinor release_version
        );
    in
    lib.nameValuePair attrName (
      callPackage ./common (
        {
          inherit
            officialRelease
            gitRelease
            version
            setupCabalVersion
            ;
        }
        // packageSetArgs # Allow overrides.
      )
    );

  ghcPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
ghcPackages // { inherit mkPackage; }
