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

    # The same settings-JSON change HEAD takes from upstream, backported onto
    # the 9.14.1 release. Three commits have to come with it, and the order is
    # the interesting part:
    #
    #   1. 9.14 carries a revert of `4eb5ad09` that master never took. Undoing
    #      it puts `m4/fp_settings.m4` and `ghc-toolchain`'s `Main.hs` back to
    #      master's state -- and the revert's own message says it should go
    #      "once `ghc-toolchain` becomes the default path", which is exactly
    #      what the next commit does.
    #   2. `ByteOrder` is a prerequisite of that commit, not a fix for it.
    #   3. Rodrigo's commit moves the toolchain facts out of `settings` and
    #      into `targets/default.target`, which is what leaves the settings
    #      file small enough to be worth typing.
    #
    # Reverting first is what makes this tractable: it takes the conflicts on
    # (3) from three files down to one.
    "9.14.1".patches =
      map
        (
          {
            name,
            rev,
            hash,
          }:
          fetchpatch {
            inherit name hash;
            url = "https://gitlab.haskell.org/obsidiansystems/ghc/-/commit/${rev}.diff";
            # A release ships the testsuite as its own tarball, so `-src.tar.xz` has
            # no `testsuite/` for these hunks to land in and `patch` fails with
            # `can't find file to patch`. HEAD does not need this: a git checkout
            # carries the testsuite inline. The dropped hunks are the expected
            # output of the settings tests, which `passthru.testsuite` runs against
            # the separate tarball.
            excludes = [ "testsuite/*" ];
          }
        )
        [
          {
            name = "reapply-drop-llvm-tool-fallbacks.patch";
            rev = "38e365b11dff7b5f61bd0ccbbb5eeec41a98e93c";
            hash = "sha256-nwLzGeZmBzsgfmYPdeSTxk7ghH/iC5haqGSdBPeP2EY=";
          }
          {
            name = "ghc-toolchain-byteorder.patch";
            rev = "448f1c4a51783e4c0e158336127e0ef11dade653";
            hash = "sha256-A7829kHvx6oPULpD2BhNyXKRuw8ySSkIOFLPp8XimBM=";
          }
          {
            name = "read-target-files-not-settings.patch";
            rev = "24fec89ea6d3f3320b73def8161fbe767ba5cb64";
            hash = "sha256-JYVlbaC5Sr+9inPc6JfI9s8P/jngS1iGPZAN5yqBQCo=";
          }
          {
            name = "settings-json-scalars.patch";
            rev = "241c34ffe857cb020377ea5232863f620d14ea8a";
            hash = "sha256-YDH2ZhTNPdiUQwIWuaFoQl8CeVK/V8Iz2uEFM5VJAqM=";
          }
          # Independent of the above: `ghc-toolchain` and `ghc-toolchain-bin`
          # are the only packages in the GHC tree that declare no `license:` at
          # all, so cabal2nix reports them as `license = "unknown"`. Fixing that
          # upstream beats asserting BSD-3 in an override here.
          {
            name = "ghc-toolchain-declare-license.patch";
            rev = "6eb4530e915fd58c41664958139c94ff36f0baef";
            hash = "sha256-4iduZgtYDGUaFI50uZXLbvS+zur1OcMt/E+ysHAYLNc=";
          }
        ];

    "9.15".setupCabalVersion = "3_16_1_0";
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
      # Independent of the above, and on its own branch for that reason:
      # `ghc-toolchain` and `ghc-toolchain-bin` are the only packages in the GHC
      # tree that declare no `license:` at all, so cabal2nix reports them as
      # `license = "unknown"`. The 9.14 list has the cherry-pick of this onto
      # its own branch; each release takes the commit from the branch it would
      # actually be proposed on, so amending one cannot silently retarget the
      # other.
      (fetchpatch {
        name = "ghc-toolchain-declare-license.patch";
        url = "https://gitlab.haskell.org/obsidiansystems/ghc/-/commit/0e94c15d7f8ec4890a35bd0253ff65b91c87e32c.diff";
        hash = "sha256-4iduZgtYDGUaFI50uZXLbvS+zur1OcMt/E+ysHAYLNc=";
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
            patches
            ;
        }
        // packageSetArgs # Allow overrides.
      )
    );

  ghcPackages = lib.mapAttrs' (version: args: mkPackage (args // { inherit version; })) versions;
in
ghcPackages // { inherit mkPackage; }
