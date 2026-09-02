# Version table for the split GHC package sets.
#
# Mirrors `gcc/ng/default.nix`: a table of versions, a `mkPackage` that turns one
# table entry into a set, and `ghcVersions` / `packageSetArgs` escape hatches so
# a caller can add or override a version without editing this file.
{
  lib,
  callPackage,
  fetchpatch,
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
    "9.14.1".officialRelease.testsuiteSha256 = "1va5ls4ng32hq8236w2aq5k0gjwxzdmwgfjf6b8z7pgpy0hzrbl4";

    "9.15".setupCabalVersion = "3_16_1_0";
    "9.15".typedSettings = true;
    # Tree-wide, so it belongs here rather than in `head/packages/`. It is the
    # change this package set has been carrying as four hand-maintained patches;
    # taking it from the branch it was submitted on keeps the two in step, and
    # the snapshot below is pinned to its parent so it applies exactly.
    "9.15".patches = [
      (fetchpatch {
        name = "settings-json-scalars.patch";
        url = "https://gitlab.haskell.org/obsidiansystems/ghc/-/commit/f6c9436a55f5835702ffe70bf54b89aa98d909ee.diff";
        hash = "sha256-Tvo951det5L3CpXAPYQBEW27aXwiGaBw4wQgEySX+5E=";
      })
    ];
    "9.15".gitRelease = {
      version = "9.15.20260901";
      date = "2026-09-01";
      rev = "44d7788f24e7475abd28019833b90ab8eff23ee5";
      sha256 = "sha256-GdoRLR5mqH/QhDsroQlMmryk0c10WSs6Uc8e8eFTRyc=";
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
      typedSettings ? false,
      patches ? [ ],
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
      # (`ghcNG-9_14`) because attribute paths in `pkgs` may not contain dots.
      attrName =
        args.name or (if gitRelease != null then "head" else lib.versions.majorMinor release_version);
    in
    lib.nameValuePair attrName (
      callPackage ./common (
        {
          inherit
            officialRelease
            gitRelease
            version
            setupCabalVersion
            typedSettings
            patches
            ;
        }
        // packageSetArgs # Allow overrides.
      )
    );

  ghcPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
ghcPackages // { inherit mkPackage; }
