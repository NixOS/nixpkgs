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
  cabal-install = (dontCheck (super.cabal-install)).overrideScope (self: super: { Cabal = self.Cabal_1_24_2_0; });

  # Build jailbreak-cabal with the latest version of Cabal.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_24_2_0; };

  gtk2hs-buildtools = super.gtk2hs-buildtools.override { Cabal = self.Cabal_1_24_2_0; };

  Extra = appendPatch super.Extra (pkgs.fetchpatch {
    url = "https://github.com/seereason/sr-extra/commit/29787ad4c20c962924b823d02a7335da98143603.patch";
    sha256 = "193i1xmq6z0jalwmq0mhqk1khz6zz0i1hs6lgfd7ybd6qyaqnf5f";
  });

  # haddock: No input file(s).
  nats = dontHaddock super.nats;
  bytestring-builder = dontHaddock super.bytestring-builder;

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

  timezone-olson = doJailbreak super.timezone-olson;
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
  graphviz = dontCheck (appendPatch super.graphviz ./patches/graphviz-fix-ghc710.patch);

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
  haddock = dontCheck self.haddock_2_16_1;

  # haddock-api >= 2.17 is GHC 8.0 only
  haddock-api = self.haddock-api_2_16_1;
  haddock-library = self.haddock-library_1_2_1;

  # lens-family-th >= 0.5.0.0 is GHC 8.0 only
  lens-family-th = self.lens-family-th_0_4_1_0;

  # The tests in vty-ui do not build, but vty-ui itself builds.
  vty-ui = enableCabalFlag super.vty-ui "no-tests";

  # https://github.com/fpco/stackage/issues/1112
  vector-algorithms = addBuildDepends (dontCheck super.vector-algorithms)
    [ self.mtl self.mwc-random ];

  # https://github.com/thoughtpolice/hs-ed25519/issues/13
  ed25519 = dontCheck super.ed25519;

  # https://github.com/well-typed/hackage-security/issues/157
  # https://github.com/well-typed/hackage-security/issues/158
  hackage-security = dontHaddock (dontCheck super.hackage-security);

  # Breaks a dependency cycle between QuickCheck and semigroups
  hashable = dontCheck super.hashable;
  unordered-containers = dontCheck super.unordered-containers;

  # GHC versions prior to 8.x require additional build inputs.
  distributive = addBuildDepend super.distributive self.semigroups;
  mono-traversable = addBuildDepend super.mono-traversable self.semigroups;
  attoparsec = addBuildDepends super.attoparsec (with self; [semigroups fail]);
  Glob = addBuildDepends super.Glob (with self; [semigroups]);
  aeson = disableCabalFlag (addBuildDepend super.aeson self.semigroups) "old-locale";
  bytes = addBuildDepend super.bytes self.doctest;
  case-insensitive = addBuildDepend super.case-insensitive self.semigroups;
  hoauth2 = overrideCabal super.hoauth2 (drv: { testDepends = (drv.testDepends or []) ++ [ self.wai self.warp ]; });
  hslogger = addBuildDepend super.hslogger self.HUnit;
  intervals = addBuildDepends super.intervals (with self; [doctest QuickCheck]);
  lens = addBuildDepends super.lens (with self; [doctest generic-deriving nats simple-reflect]);
  optparse-applicative = addBuildDepend super.optparse-applicative self.semigroups;
  QuickCheck = addBuildDepend super.QuickCheck self.semigroups;
  semigroups = addBuildDepends super.semigroups (with self; [hashable tagged text unordered-containers]);
  texmath = addBuildDepend super.texmath self.network-uri;
  yesod-auth-oauth2 = overrideCabal super.yesod-auth-oauth2 (drv: { testDepends = (drv.testDepends or []) ++ [ self.load-env self.yesod ]; });
  # cereal must have `fail` in pre-ghc-8.0.x versions
  # also tests require bytestring>=0.10.8.1
  cereal = dontCheck (addBuildDepend super.cereal self.fail);

  # Moved out from common as no longer the case for GHC8
  ghc-mod = super.ghc-mod.override { cabal-helper = self.cabal-helper_0_6_3_1; };

}
