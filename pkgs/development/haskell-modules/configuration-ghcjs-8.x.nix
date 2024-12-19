# GHCJS package fixes
#
# Please insert new packages *alphabetically*
# in the OTHER PACKAGES section.
{ pkgs, haskellLib }:

let
  removeLibraryHaskellDepends =
    pnames: depends: builtins.filter (e: !(builtins.elem (e.pname or "") pnames)) depends;
in

with haskellLib;

self: super:

## GENERAL SETUP BASE PACKAGES
{
  inherit (self.ghc.bootPkgs)
    jailbreak-cabal
    alex
    happy
    gtk2hs-buildtools
    rehoo
    hoogle
    ;

  # Test suite fails; https://github.com/ghcjs/ghcjs-base/issues/133
  ghcjs-base = dontCheck (
    self.callPackage ../compilers/ghcjs/ghcjs-base.nix {
      fetchFromGitHub = pkgs.buildPackages.fetchFromGitHub;
      aeson = self.aeson_1_5_6_0;
    }
  );

  # Included in ghcjs itself
  ghcjs-prim = null;

  ghcjs-websockets = markUnbroken super.ghcjs-websockets;

  # GHCJS does not ship with the same core packages as GHC.
  # https://github.com/ghcjs/ghcjs/issues/676
  stm = doJailbreak self.stm_2_5_3_1;
  exceptions = dontCheck self.exceptions_0_10_8;

  ## OTHER PACKAGES

  # Runtime exception in tests, missing C API h$realloc
  base-compat-batteries = dontCheck super.base-compat-batteries;

  # nodejs crashes during test
  ChasingBottoms = dontCheck super.ChasingBottoms;

  # runs forever
  text-short = dontCheck super.text-short;

  # doctest doesn't work on ghcjs, but sometimes dontCheck doesn't seem to get rid of the dependency
  doctest = pkgs.lib.warn "ignoring dependency on doctest" null;

  ghcjs-dom = overrideCabal (drv: {
    libraryHaskellDepends = with self; [
      ghcjs-base
      ghcjs-dom-jsffi
      text
      transformers
    ];
    configureFlags = [
      "-fjsffi"
      "-f-webkit"
    ];
  }) super.ghcjs-dom;

  ghcjs-dom-jsffi = overrideCabal (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or [ ]) ++ [
      self.ghcjs-base
      self.text
    ];
    broken = false;
  }) super.ghcjs-dom-jsffi;

  # https://github.com/Deewiant/glob/issues/39
  Glob = dontCheck super.Glob;

  # Test fails to compile during the hsc2hs stage
  hashable = dontCheck super.hashable;

  # uses doctest
  http-types = dontCheck super.http-types;

  jsaddle = overrideCabal (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or [ ]) ++ [ self.ghcjs-base ];
  }) super.jsaddle;

  # Tests hang, possibly some issue with tasty and race(async) usage in the nonTerminating tests
  logict = dontCheck super.logict;

  patch = dontCheck super.patch;

  # TODO: tests hang
  pcre-light = dontCheck super.pcre-light;

  # Terminal test not supported on ghcjs
  QuickCheck = dontCheck super.QuickCheck;

  reflex = overrideCabal (drv: {
    libraryHaskellDepends = (drv.libraryHaskellDepends or [ ]) ++ [ self.ghcjs-base ];
  }) super.reflex;

  reflex-dom = overrideCabal (drv: {
    libraryHaskellDepends = removeLibraryHaskellDepends [ "jsaddle-webkit2gtk" ] (
      drv.libraryHaskellDepends or [ ]
    );
  }) super.reflex-dom;

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

  hspec = self.hspec_2_7_10;
  hspec-core = self.hspec-core_2_7_10;
  hspec-meta = self.hspec-meta_2_7_8;
  hspec-discover = self.hspec-discover_2_7_10;

  # ReferenceError: h$primop_ShrinkSmallMutableArrayOp_Char is not defined
  unordered-containers = dontCheck super.unordered-containers;

  # Without this revert, test suites using tasty fail with:
  # ReferenceError: h$getMonotonicNSec is not defined
  # https://github.com/UnkindPartition/tasty/pull/345#issuecomment-1538216407
  tasty = appendPatch (pkgs.fetchpatch {
    name = "tasty-ghcjs.patch";
    url = "https://github.com/UnkindPartition/tasty/commit/e692065642fd09b82acccea610ad8f49edd207df.patch";
    revert = true;
    relative = "core";
    hash = "sha256-ryABU2ywkVOEPC/jWv8humT3HaRpCwMYEk+Ux3hhi/M=";
  }) super.tasty;

  # Tests take unacceptably long.
  vector = dontCheck super.vector;
}
