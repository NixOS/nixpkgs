# One rung of the `ghc/ng` bootstrap, as a compiler configuration.
#
# `pkgs/top-level/haskell-packages.nix` builds each rung with
# `callPackage ../development/haskell-modules { ... }` exactly as it does for
# every other compiler, and passes this as `compilerConfig`.
#
# There are three rungs, differing only in which overlays apply and which
# compiler builds them. Nothing here names a compiler: that is the caller's
# `ghc` argument, taken from `buildPackages.haskell.compiler.<the rung below>`.
# That indirection is what makes the chain late-bound, and why there is no
# ladder object anywhere.
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
#           versions layered on, not a special-purpose scope.
{
  pkgs,
  haskellLib,

  # The release, from `../compilers/ghc/ng/default.nix`.
  ghcVersion,

  # Which rung. See above.
  stage,

  # The bootstrap compiler's own `configuration-ghc-*.nix`, for the rungs it
  # builds.
  #
  # The tools and stage1 rungs pass one, because they really are built against
  # the bootstrap compiler's shipped libraries and want them nulled as usual.
  # stage2 does not: those files null the core libraries on the premise that the
  # compiler ships them, and that is the premise the rung exists to break. It is
  # where they are built.
  bootstrapConfig ? (_: _: { }),
}:

let
  inherit (pkgs) lib;

  overlays = pkgs.callPackage ../compilers/ghc/ng/common/overlay.nix {
    inherit haskellLib;
    inherit (ghcVersion) ghcSrc packagesDir setupCabalVersion;
  };

  # `setupCabal` applies to the rungs the bootstrap compiler builds. There it is
  # an ordinary version choice within one set -- those packages and the `Cabal`
  # they pick are compiled by the same compiler.
  #
  # stage2 is not one of them, and must not be: its `Cabal` is stage1-built and
  # linked into `ghc-pkg`, while its `Setup.hs` files need one the *build*
  # compiler can load. Those reach it from the tools rung, through
  # `buildHaskellPackages`, because the scope is spliced -- see `alwaysSplice`.
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
      # `generic-builder` passes `--with-ghc` only when cross-compiling, and
      # natively Cabal would find the bootstrap compiler on PATH.
      overlays.explicitCompilerEverywhere
      overlays.systemCxxStdLib
      overlays.hackageCore
      overlays.stage2
    ];
  };
in

lib.composeManyExtensions ([ bootstrapConfig ] ++ overlaysFor.${stage})
