# One GHC version's worth of the split package set.
#
# This is NOT a `makeScopeWithSplicing'` scope. The boot libraries live in the
# ordinary Haskell package set for this compiler -- they are Hackage-namespace
# packages (`base`, `rts`, `ghc-prim`, `ghc`, ...) and belong beside every other
# Haskell package, replacing the `= null` holes in
# `haskell-modules/configuration-ghc-*.nix`.
#
# What this file provides is the version-specific raw material those expressions
# need: the source tree and the version metadata.
{
  lib,
  callPackage,
  officialRelease ? null,
  gitRelease ? null,
  version ? null,
  # Tree-wide patches only. Anything that touches a single component belongs in
  # `./patches/<component>/`, applied by `./overlay.nix` to that package alone --
  # see the note there.
  patches ? [ ],

  # See the note on `setupCabalVersion` in ./overlay.nix.
  setupCabalVersion ? "3_12_1_0",
  ...
}:

let
  # `9.14` or `head`, matching the directory beside `./common` that holds this
  # version's generated expressions and patches.
  # A real path, not `toString ../. + "..."`. A string path is not copied into
  # the store, so patches referenced through it resolve to nothing inside the
  # sandbox -- the build fails with "No such file or directory" naming a file
  # that plainly exists in the working tree.
  versionDir =
    ../. + ("/" + (if gitRelease != null then "head" else lib.versions.majorMinor releaseInfo.release_version));

  inherit
    (import ./common-let.nix {
      inherit
        lib
        gitRelease
        officialRelease
        version
        ;
    })
    releaseInfo
    ghc_meta
    ;
in
{
  inherit (releaseInfo) version release_version;
  inherit versionDir setupCabalVersion;
  inherit ghc_meta;

  # The generated expressions for this version. cabal2nix bakes the version
  # into each one, so these cannot be shared between releases.
  packagesDir = versionDir + "/packages";

  # Platform-independent: no compiler, no C toolchain, no `./configure`.
  # See the header of `./src.nix` for why.
  ghcSrc = callPackage ./src.nix {
    inherit
      officialRelease
      gitRelease
      patches
      ;
    inherit (releaseInfo) version release_version;
  };
}
