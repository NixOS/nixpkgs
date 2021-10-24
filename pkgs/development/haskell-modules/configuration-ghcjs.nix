# GHCJS package fixes
#
# Please insert new packages *alphabetically*
# in the OTHER PACKAGES section.
{ pkgs, haskellLib }:

let
  removeLibraryHaskellDepends = pnames: depends:
    builtins.filter (e: !(builtins.elem (e.pname or "") pnames)) depends;
in

with haskellLib;

self: super:

## GENERAL SETUP BASE PACKAGES
{
  inherit (self.ghc.bootPkgs)
    jailbreak-cabal alex happy gtk2hs-buildtools rehoo hoogle;

  ghcjs-base = dontCheck (self.callPackage ../compilers/ghcjs/ghcjs-base.nix {
    fetchgit = pkgs.buildPackages.fetchgit;
  });

  # GHCJS does not ship with the same core packages as GHC.
  # https://github.com/ghcjs/ghcjs/issues/676
  stm = doJailbreak self.stm_2_5_0_1;
  exceptions = dontCheck self.exceptions_0_10_4;

## OTHER PACKAGES

  # Runtime exception in tests, missing C API h$realloc
  base-compat-batteries = dontCheck super.base-compat-batteries;

  # nodejs crashes during test
  ChasingBottoms = dontCheck super.ChasingBottoms;

  # doctest doesn't work on ghcjs, but sometimes dontCheck doesn't seem to get rid of the dependency
  doctest = pkgs.lib.warn "ignoring dependency on doctest" null;

  ghcjs-dom = overrideCabal super.ghcjs-dom (drv: {
    libraryHaskellDepends = with self; [
      ghcjs-base ghcjs-dom-jsffi text transformers
    ];
    configureFlags = [ "-fjsffi" "-f-webkit" ];
  });

  ghcjs-dom-jsffi = overrideCabal super.ghcjs-dom-jsffi (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ self.ghcjs-base self.text ];
    broken = false;
  });

  # https://github.com/Deewiant/glob/issues/39
  Glob = dontCheck super.Glob;

  # Test fails to compile during the hsc2hs stage
  hashable = dontCheck super.hashable;

  # uses doctest
  http-types = dontCheck super.http-types;

  jsaddle = overrideCabal super.jsaddle (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ self.ghcjs-base ];
  });

  # Tests hang, possibly some issue with tasty and race(async) usage in the nonTerminating tests
  logict = dontCheck super.logict;

  patch = dontCheck super.patch;

  # TODO: tests hang
  pcre-light = dontCheck super.pcre-light;

  # Terminal test not supported on ghcjs
  QuickCheck = dontCheck super.QuickCheck;

  reflex = overrideCabal super.reflex (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [ self.ghcjs-base ];
  });

  reflex-dom = overrideCabal super.reflex-dom (drv: {
    libraryHaskellDepends = removeLibraryHaskellDepends ["jsaddle-webkit2gtk"] (drv.libraryHaskellDepends or []);
  });

  # https://github.com/dreixel/syb/issues/21
  syb = dontCheck super.syb;

  # nodejs crashes during test
  scientific = dontCheck super.scientific;

  # Tests use TH which gives error
  tasty-quickcheck = dontCheck super.tasty-quickcheck;

  temporary = dontCheck super.temporary;

  # 2 tests fail, related to time precision
  time-compat = dontCheck super.time-compat;

  # TODO: The tests have a TH error, which has been fixed in ghc
  # https://gitlab.haskell.org/ghc/ghc/-/issues/15481 but somehow the issue is
  # still present here https://github.com/glguy/th-abstraction/issues/53
  th-abstraction = dontCheck super.th-abstraction;

  # Need hedgehog for tests, which fails to compile due to dep on concurrent-output
  zenc = dontCheck super.zenc;
}
