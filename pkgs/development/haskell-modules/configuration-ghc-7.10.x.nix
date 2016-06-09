{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 7.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Enable latest version of cabal-install.
  cabal-install = (doDistribute (dontJailbreak (dontCheck (super.cabal-install)))).overrideScope (self: super: { Cabal = self.Cabal_1_24_0_0; });

  # Jailbreaking is required for the test suite only (which we don't run).
  Cabal_1_24_0_0 = dontJailbreak (dontCheck super.Cabal_1_24_0_0);

  # Build jailbreak-cabal with the latest version of Cabal.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_24_0_0; };

  idris = overrideCabal super.idris (drv: {
    # "idris" binary cannot find Idris library otherwise while building.
    # After installing it's completely fine though. Seems like Nix-specific
    # issue so not reported.
    preBuild = "export LD_LIBRARY_PATH=$PWD/dist/build:$LD_LIBRARY_PATH";
    # https://github.com/idris-lang/Idris-dev/issues/2499
    librarySystemDepends = (drv.librarySystemDepends or []) ++ [pkgs.gmp];
  });

  Extra = appendPatch super.Extra (pkgs.fetchpatch {
    url = "https://github.com/seereason/sr-extra/commit/29787ad4c20c962924b823d02a7335da98143603.patch";
    sha256 = "193i1xmq6z0jalwmq0mhqk1khz6zz0i1hs6lgfd7ybd6qyaqnf5f";
  });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

  # requires filepath >=1.1 && <1.4
  Glob = doJailbreak super.Glob;

  # Setup: At least the following dependencies are missing: base <4.8
  hspec-expectations = overrideCabal super.hspec-expectations (drv: {
    postPatch = "sed -i -e 's|base < 4.8|base|' hspec-expectations.cabal";
  });
  utf8-string = overrideCabal super.utf8-string (drv: {
    postPatch = "sed -i -e 's|base >= 3 && < 4.8|base|' utf8-string.cabal";
  });

  # acid-state/safecopy#25 acid-state/safecopy#26
  safecopy = dontCheck (super.safecopy);

  # test suite broken, some instance is declared twice.
  # https://bitbucket.org/FlorianHartwig/attobencode/issue/1
  AttoBencode = dontCheck super.AttoBencode;

  # Test suite fails with some (seemingly harmless) error.
  # https://code.google.com/p/scrapyourboilerplate/issues/detail?id=24
  syb = dontCheck super.syb;

  # Test suite has stricter version bounds
  retry = dontCheck super.retry;

  # test/System/Posix/Types/OrphansSpec.hs:19:13:
  #    Not in scope: type constructor or class ‘Int32’
  base-orphans = dontCheck super.base-orphans;

  # Test suite fails with time >= 1.5
  http-date = dontCheck super.http-date;

  # Version 1.19.5 fails its test suite.
  happy = dontCheck super.happy;

  # Upstream was notified about the over-specified constraint on 'base'
  # but refused to do anything about it because he "doesn't want to
  # support a moving target". Go figure.
  barecheck = doJailbreak super.barecheck;

  # https://github.com/kazu-yamamoto/unix-time/issues/30
  unix-time = dontCheck super.unix-time;

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "dfeaab2aafdfefe46bf12960d069f28d2e5f1454"; # ghc-7.10 branch
      sha256 = "19kyb26nv1hdpp0kc2gaxkq5drw5ib4za0641py5i4bbf1g58yvy";
    };
    buildDepends = [ primitive ];
    license = pkgs.stdenv.lib.licenses.bsd3;
  }) {};

  # diagrams/monoid-extras#19
  monoid-extras = overrideCabal super.monoid-extras (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' monoid-extras.cabal";
  });

  # diagrams/statestack#5
  statestack = overrideCabal super.statestack (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' statestack.cabal";
  });

  # diagrams/diagrams-core#83
  diagrams-core = overrideCabal super.diagrams-core (drv: {
    prePatch = "sed -i 's|4\.8|4.9|' diagrams-core.cabal";
  });

  timezone-series = doJailbreak super.timezone-series;
  timezone-olson = doJailbreak super.timezone-olson;
  libmpd = dontCheck super.libmpd;
  xmonad-extras = overrideCabal super.xmonad-extras (drv: {
    postPatch = ''
      sed -i -e "s,<\*,<¤,g" XMonad/Actions/Volume.hs
    '';
  });

  # Workaround for a workaround, see comment for "ghcjs" flag.
  jsaddle = let jsaddle' = disableCabalFlag super.jsaddle "ghcjs";
            in addBuildDepends jsaddle' [ self.glib self.gtk3 self.webkitgtk3
                                          self.webkitgtk3-javascriptcore ];

  # https://github.com/lymar/hastache/issues/47
  hastache = dontCheck super.hastache;

  # The compat library is empty in the presence of mtl 2.2.x.
  mtl-compat = dontHaddock super.mtl-compat;

  # https://github.com/bos/bloomfilter/issues/11
  bloomfilter = dontHaddock (appendConfigureFlag super.bloomfilter "--ghc-option=-XFlexibleContexts");

  # https://github.com/ocharles/tasty-rerun/issues/5
  tasty-rerun = dontHaddock (appendConfigureFlag super.tasty-rerun "--ghc-option=-XFlexibleContexts");

  # http://hub.darcs.net/ivanm/graphviz/issue/5
  graphviz = dontCheck (dontJailbreak (appendPatch super.graphviz ./patches/graphviz-fix-ghc710.patch));

  # https://github.com/HugoDaniel/RFC3339/issues/14
  timerep = dontCheck super.timerep;

  # Required to fix version 0.91.0.0.
  wx = dontHaddock (appendConfigureFlag super.wx "--ghc-option=-XFlexibleContexts");

  # Inexplicable haddock failure
  # https://github.com/gregwebs/aeson-applicative/issues/2
  aeson-applicative = dontHaddock super.aeson-applicative;

  # GHC 7.10.1 is affected by https://github.com/srijs/hwsl2/issues/1.
  hwsl2 = dontCheck super.hwsl2;

  # https://github.com/haskell/haddock/issues/427
  haddock = dontCheck super.haddock;

  # haddock-api >= 2.17 is GHC 8.0 only
  haddock-api = self.haddock-api_2_16_1;

  # lens-family-th >= 0.5.0.0 is GHC 8.0 only
  lens-family-th = self.lens-family-th_0_4_1_0;

  # cereal must have `fail` in pre-ghc-8.0.x versions
  cereal = addBuildDepend super.cereal self.fail;

  # The tests in vty-ui do not build, but vty-ui itself builds.
  vty-ui = enableCabalFlag super.vty-ui "no-tests";

  # https://github.com/fpco/stackage/issues/1112
  vector-algorithms = dontCheck super.vector-algorithms;

  # Trigger rebuild to mitigate broken packaes on Hydra.
  amazonka-core = triggerRebuild super.amazonka-core 1;

  # https://github.com/thoughtpolice/hs-ed25519/issues/13
  ed25519 = dontCheck super.ed25519;

  # https://github.com/well-typed/hackage-security/issues/157
  # https://github.com/well-typed/hackage-security/issues/158
  hackage-security = dontHaddock (dontCheck super.hackage-security);

  # GHC versions prior to 8.x require additional build inputs.
  aeson = disableCabalFlag (addBuildDepend super.aeson self.semigroups) "old-locale";
  case-insensitive = addBuildDepend super.case-insensitive self.semigroups;
  bytes = addBuildDepend super.bytes self.doctest;
  semigroups = addBuildDepends super.semigroups (with self; [hashable tagged text unordered-containers]);
  intervals = addBuildDepends super.intervals (with self; [doctest QuickCheck]);

  # Moved out from common as no longer the case for GHC8
  ghc-mod = super.ghc-mod.override { cabal-helper = self.cabal-helper_0_6_3_1; };
}
