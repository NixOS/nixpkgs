# One rung of the GHC bootstrap, as an ordinary Haskell package set.
#
# There are three, and they differ only in which overlays apply and which
# compiler builds them. Nothing here binds the compiler: it arrives as `ghc`,
# so the caller in `pkgs/top-level/haskell-packages.nix` can take it from
# `buildPackages.haskell.compiler.<previous rung>` the way every other Haskell
# set does. That indirection is what makes the chain late-bound, and it is why
# there is no ladder object anywhere.
#
#   tools   build-platform programs from the GHC tree -- `deriveConstants`,
#           `genapply`, `ghc-toolchain-bin` and friends. Built by the bootstrap
#           compiler against *its* boot libraries, so nothing here may name a
#           library we build, or the set does not terminate:
#           `rts -> deriveConstants -> base -> ghc-internal -> rts`.
#
#   stage1  the compiler packages, with the `+bootstrap` cabal flags so they
#           compile against the old `base`. Also built by the bootstrap
#           compiler. Exists because the boot libraries cannot be:
#           `rts/Apply.cmm` uses `PUSH_BH_UPD_FRAME`, a built-in of *9.14's*
#           Cmm parser that a 9.10 bootstrap does not have.
#
#   stage2  the boot libraries proper, built by the assembled stage1 compiler.
#           `base` lives here, and so does the rest of Hackage -- this is an
#           ordinary package set with the GHC-tree packages and the pinned core
#           versions layered on as overlays, not a special-purpose scope.
{
  lib,
  callPackage,
  haskellLib,

  # The release, from ./default.nix.
  ghcVersion,

  # Which rung. See above.
  stage,

  # The set to extend: an ordinary Haskell package set for the platform this
  # rung's packages are *for*.
  basePkgs,

  # The rung whose build-platform programs this one needs. `generic-builder`
  # resolves `libraryToolDepends` and `setupHaskellDepends` out of
  # `buildHaskellPackages`, and the GHC-tree packages name `deriveConstants`
  # and friends, so that set has to carry the tools.
  #
  # `null` for the tools rung itself, which has nothing below it.
  toolsPkgs ? null,

  # The compiler that builds this rung, from
  # `buildPackages.haskell.compiler.<previous rung>`. `null` leaves whatever
  # `basePkgs` already uses, which is what the tools and stage1 rungs want --
  # they are built by the bootstrap compiler.
  ghc ? null,
}:

let
  overlays = callPackage ./common/overlay.nix {
    inherit haskellLib;
    inherit (ghcVersion) ghcSrc packagesDir setupCabalVersion;
  };

  composeAll = lib.foldl' lib.composeExtensions (_: _: { });

  # `setupCabal` applies to every rung: `setupHaskellDepends` resolve from
  # `buildHaskellPackages`, so a package's `Setup.hs` is compiled against the
  # Cabal of the set that *builds* it, not the one being built.
  overlaysFor = {
    tools = [
      overlays.setupCabal
      overlays.tools
    ];
    stage1 = [
      overlays.setupCabal
      overlays.tools
      overlays.stage1
    ];
    stage2 = [
      # First: make every package in the set name its compiler explicitly.
      # Splicing is the identity when `pkgs == buildPackages`, so on a native
      # build a package would otherwise pick up the set's own `alex` and
      # `happy` -- compiled by the compiler under construction.
      overlays.explicitCompilerEverywhere
      overlays.setupCabal
      overlays.systemCxxStdLib
      overlays.buildTools
      overlays.hackageCore
      overlays.stage2
    ];
  };
in

(basePkgs.override (
  lib.optionalAttrs (toolsPkgs != null) { buildHaskellPackages = toolsPkgs; }
  // lib.optionalAttrs (ghc != null) { inherit ghc; }
  // lib.optionalAttrs (stage == "stage2") {
    # NOT `configuration-ghc-*.nix`: that nulls the core libraries on the
    # premise that the compiler ships them, which is the premise this rung
    # exists to break. It is where they are built.
    compilerConfig = _: _: { };
  }
)).extend
  (composeAll overlaysFor.${stage})
