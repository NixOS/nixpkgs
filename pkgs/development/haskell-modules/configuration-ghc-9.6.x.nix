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

  ghc-lib = doDistribute self.ghc-lib_9_6_1_20230312;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_6_1_20230312;
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
  # Forbids base >= 4.18, fix proposed: https://github.com/well-typed/cborg/pull/312
  cborg = jailbreakForCurrentVersion super.cborg "0.2.8.0";
  cborg-json = jailbreakForCurrentVersion super.cborg-json "0.2.5.0";
  serialise = jailbreakForCurrentVersion super.serialise "0.2.6.0";

  #
  # Too strict bounds, waiting on Hackage release in nixpkgs
  #

  # base >= 4.18 is allowed in those newer versions
  boring = assert !(self ? boring_0_2_1); doJailbreak super.boring;
  these = assert !(self ? assoc_1_2); doJailbreak super.these;

  # XXX: We probably should be using semigroupoids 6.0.1 which is intended for 9.6
  semigroupoids = doJailbreak super.semigroupoids;
  # XXX: 1.3 supports 9.6 properly, but is intended for bifunctors >= 5.6
  semialign = doJailbreak super.semialign;

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
  haskell-language-server = super.haskell-language-server.override {
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

  ghc-exactprint = unmarkBroken (addBuildDepends (with self.ghc-exactprint.scope; [
   HUnit Diff data-default extra fail free ghc-paths ordered-containers silently syb
  ]) super.ghc-exactprint_1_7_0_0);

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
    hie-compat;
}
