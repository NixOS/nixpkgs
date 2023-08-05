{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

  jailbreakWhileRevision = rev:
    overrideCabal (old: {
      jailbreak = assert old.revision or "0" == toString rev; true;
    });
  checkAgainAfter = pkg: ver: msg: act:
    if builtins.compareVersions pkg.version ver <= 0 then act
    else
      builtins.throw "Check if '${msg}' was resolved in ${pkg.pname} ${pkg.version} and update or remove this";
  jailbreakForCurrentVersion = p: v: checkAgainAfter p v "bad bounds" (doJailbreak p);
in

self: super: {
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # terminfo is not built if GHC is a cross compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_5;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version deviations from Stackage LTS
  #

  doctest = doDistribute super.doctest_0_21_1;
  inspection-testing = doDistribute self.inspection-testing_0_5_0_1; # allows base >= 4.18
  OneTuple = doDistribute (dontCheck super.OneTuple_0_4_1_1); # allows base >= 4.18
  primitive = doDistribute (dontCheck self.primitive_0_7_4_0); # allows base >= 4.18
  http-api-data = doDistribute self.http-api-data_0_5_1; # allows base >= 4.18
  attoparsec-iso8601 = doDistribute self.attoparsec-iso8601_1_1_0_0; # for http-api-data-0.5.1
  tagged = doDistribute self.tagged_0_8_7; # allows template-haskell-2.20
  some = doDistribute self.some_1_0_5;
  tasty-inspection-testing = doDistribute self.tasty-inspection-testing_0_2;
  th-abstraction = doDistribute self.th-abstraction_0_5_0_0;
  th-desugar = doDistribute self.th-desugar_1_15;
  turtle = doDistribute self.turtle_1_6_1;
  aeson = doDistribute self.aeson_2_1_2_1;
  memory = doDistribute self.memory_0_18_0;
  semigroupoids = doDistribute self.semigroupoids_6_0_0_1;
  bifunctors = doDistribute self.bifunctors_5_6_1;
  cabal-plan = doDistribute self.cabal-plan_0_7_3_0;
  base-compat = doDistribute self.base-compat_0_13_0;
  base-compat-batteries = doDistribute self.base-compat-batteries_0_13_0;
  semialign = doDistribute self.semialign_1_3;
  assoc = doDistribute self.assoc_1_1;
  strict = doDistribute self.strict_0_5;

  ghc-lib = doDistribute self.ghc-lib_9_6_2_20230523;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_6_2_20230523;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_6_0_0;

  # allows mtl, template-haskell, text and transformers
  hedgehog = doDistribute self.hedgehog_1_2;
  # allows base >= 4.18
  tasty-hedgehog = doDistribute self.tasty-hedgehog_1_4_0_1;

  # v0.1.6 forbids base >= 4.18
  singleton-bool = doDistribute super.singleton-bool_0_1_7;

  #
  # Too strict bounds without upstream fix
  #

  # Forbids transformers >= 0.6
  quickcheck-classes-base = doJailbreak super.quickcheck-classes-base;
  # Forbids mtl >= 2.3
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  # Forbids base >= 4.18
  cabal-install-solver = doJailbreak super.cabal-install-solver;
  cabal-install = doJailbreak super.cabal-install;

  # Forbids base >= 4.18, fix proposed: https://github.com/sjakobi/newtype-generics/pull/25
  newtype-generics = jailbreakForCurrentVersion super.newtype-generics "0.6.2";

  cborg-json = jailbreakForCurrentVersion super.cborg-json "0.2.5.0";
  serialise = jailbreakForCurrentVersion super.serialise "0.2.6.0";

  #
  # Too strict bounds, waiting on Hackage release in nixpkgs
  #

  #
  # Compilation failure workarounds
  #

  # Add missing Functor instance for Tuple2
  # https://github.com/haskell-foundation/foundation/pull/572
  foundation = appendPatches [
      (pkgs.fetchpatch {
        name = "foundation-pr-572.patch";
        url =
          "https://github.com/haskell-foundation/foundation/commit/d3136f4bb8b69e273535352620e53f2196941b35.patch";
        sha256 = "sha256-oPadhQdCPJHICdCPxn+GsSQUARIYODG8Ed6g2sK+eC4=";
        stripLen = 1;
      })
    ] (super.foundation);

  # Add support for time 1.10
  # https://github.com/vincenthz/hs-hourglass/pull/56
  hourglass = appendPatches [
      (pkgs.fetchpatch {
        name = "hourglass-pr-56.patch";
        url =
          "https://github.com/vincenthz/hs-hourglass/commit/cfc2a4b01f9993b1b51432f0a95fa6730d9a558a.patch";
        sha256 = "sha256-gntZf7RkaR4qzrhjrXSC69jE44SknPDBmfs4z9rVa5Q=";
      })
    ] (super.hourglass);


  # Test suite doesn't compile with base-4.18 / GHC 9.6
  # https://github.com/dreixel/syb/issues/40
  syb = dontCheck super.syb;

  # 2023-04-03: plugins disabled for hls 1.10.0.0 based on
  #
  haskell-language-server =
    let
      # TODO: HLS-2.0.0.0 added support for the foumolu plugin for ghc-9.6.
      # However, putting together all the overrides to get the latest
      # version of fourmolu compiling together with ghc-9.6 and HLS is a
      # little annoying, so currently fourmolu has been disabled.  We should
      # try to enable this at some point in the future.
      hlsWithFlags = disableCabalFlag "fourmolu" super.haskell-language-server;
    in
    hlsWithFlags.override {
      hls-ormolu-plugin = null;
      hls-floskell-plugin = null;
      hls-fourmolu-plugin = null;
      hls-hlint-plugin = null;
      hls-stylish-haskell-plugin = null;
    };

  MonadRandom = super.MonadRandom_0_6;
  unix-compat = super.unix-compat_0_7;
  lifted-base = dontCheck super.lifted-base;
  hw-fingertree = dontCheck super.hw-fingertree;
  hw-prim = dontCheck (doJailbreak super.hw-prim);
  stm-containers = dontCheck super.stm-containers;
  regex-tdfa = dontCheck super.regex-tdfa;
  rebase = doJailbreak super.rebase_1_20;
  rerebase = doJailbreak super.rerebase_1_20;
  hiedb = dontCheck super.hiedb;
  retrie = dontCheck (super.retrie);

  # break infinite recursion with foldable1-classes-compat's test suite, which depends on 'these'.
  these = doDistribute (super.these_1_2.override { foldable1-classes-compat = dontCheck super.foldable1-classes-compat; });

  ghc-exactprint = unmarkBroken (addBuildDepends (with self.ghc-exactprint.scope; [
   HUnit Diff data-default extra fail free ghc-paths ordered-containers silently syb
  ]) super.ghc-exactprint_1_7_0_1);

  inherit (pkgs.lib.mapAttrs (_: doJailbreak ) super)
    hls-cabal-plugin
    algebraic-graphs
    co-log-core
    lens
    cryptohash-sha1
    cryptohash-md5
    ghc-trace-events
    tasty-hspec
    constraints-extras
    tree-diff
    implicit-hie-cradle
    focus
    hie-compat
    xmonad-contrib              # mtl >=1 && <2.3
    dbus       # template-haskell >=2.18 && <2.20, transformers <0.6, unix <2.8
  ;

  # Apply workaround for Cabal 3.8 bug https://github.com/haskell/cabal/issues/8455
  # by making `pkg-config --static` happy. Note: Cabal 3.9 is also affected, so
  # the GHC 9.6 configuration may need similar overrides eventually.
  X11-xft = __CabalEagerPkgConfigWorkaround super.X11-xft;
  # Jailbreaks for https://github.com/gtk2hs/gtk2hs/issues/323#issuecomment-1416723309
  glib = __CabalEagerPkgConfigWorkaround (doJailbreak super.glib);
  cairo = __CabalEagerPkgConfigWorkaround (doJailbreak super.cairo);
  pango = __CabalEagerPkgConfigWorkaround (doJailbreak super.pango);

  # Pending text-2.0 support https://github.com/gtk2hs/gtk2hs/issues/327
  gtk = doJailbreak super.gtk;

  # Doctest comments have bogus imports.
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # Fix ghc-9.6.x build errors.
  libmpd = appendPatch
    (pkgs.fetchpatch { url = "https://github.com/vimus/libmpd-haskell/pull/138.patch";
                       sha256 = "sha256-CvvylXyRmoCoRJP2MzRwL0SBbrEzDGqAjXS+4LsLutQ=";
                     })
    super.libmpd;

}
