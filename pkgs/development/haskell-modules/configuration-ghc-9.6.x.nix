{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

  jailbreakWhileRevision = rev:
    overrideCabal (old: {
      jailbreak = assert old.revision or "0" == toString rev; true;
    });
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

  th-desugar = doDistribute self.th-desugar_1_15;
  th-abstraction = doDistribute self.th-abstraction_0_5_0_0;
  tagged = doDistribute self.tagged_0_8_7; # allows template-haskell-2.20
  primitive = doDistribute (dontCheck self.primitive_0_7_4_0); # allows base >= 4.18
  indexed-traversable = doDistribute super.indexed-traversable_0_1_2_1; # allows base >= 4.18
  OneTuple = doDistribute (dontCheck super.OneTuple_0_4_1_1); # allows base >= 4.18
  inspection-testing = doDistribute self.inspection-testing_0_5_0_1; # allows base >= 4.18
  tasty-inspection-testing = doDistribute self.tasty-inspection-testing_0_2;
  # Too strict bounds on ghc-prim and template-haskell
  aeson = doDistribute (doJailbreak self.aeson_2_1_2_1);
  # Too strict bounds on ghc-prim
  memory = doDistribute self.memory_0_18_0;

  ghc-lib = doDistribute self.ghc-lib_9_6_1_20230312;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_6_1_20230312;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_6_0_0;

  #
  # Too strict bounds without upstream fix
  #

  # Forbids transformers >= 0.6
  quickcheck-classes-base = doJailbreak super.quickcheck-classes-base;
  # Forbids base >= 4.18
  singleton-bool = doJailbreak super.singleton-bool;
  # Forbids base >= 4.18
  unliftio-core = doJailbreak super.unliftio-core;
  # Forbids mtl >= 2.3
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  # Forbids base >= 4.18
  cabal-install-solver = doJailbreak super.cabal-install-solver;
  cabal-install = doJailbreak super.cabal-install;
  # Forbids base >= 4.18
  lukko = doJailbreak super.lukko;

  #
  # Too strict bounds, waiting on Hackage release in nixpkgs
  #

  # base >= 4.18 is allowed in those newer versions
  boring = assert !(self ? boring_0_2_1); doJailbreak super.boring;
  some = assert !(self ? some_1_0_5); doJailbreak super.some;
  assoc = assert !(self ? assoc_1_1); doJailbreak super.assoc;
  these = assert !(self ? assoc_1_2); doJailbreak super.these;
  # Temporarily upgrade manually until the attribute is available
  doctest = doDistribute (overrideCabal {
    version = "0.21.1";
    sha256 = "0vgl89p6iaj2mwnd1gkpq86q1g18shdcws0p3can25algi2sldk3";
  } super.doctest_0_21_0);

  # XXX: We probably should be using semigroupoids 6.0.1 which is intended for 9.6
  semigroupoids = doJailbreak super.semigroupoids;
  # XXX: 1.3 supports 9.6 properly, but is intended for bifunctors >= 5.6
  semialign = doJailbreak super.semialign;

  #
  # Too strict bounds, waiting on Revision in nixpkgs
  #

  # Revision 7 lifts the offending bound on ghc-prim
  ed25519 = jailbreakWhileRevision 6 super.ed25519;
  # Revision 6 lifts the offending bound on base
  tar = jailbreakWhileRevision 5 super.tar;
  # Revision 2 lifts the offending bound on base
  HTTP = jailbreakWhileRevision 1 super.HTTP;
  # Revision 1 lifts the offending bound on base
  dec = jailbreakWhileRevision 0 super.dec;
  # Revision 2 lifts the offending bound on base
  cryptohash-sha256 = jailbreakWhileRevision 1 super.cryptohash-sha256;
  # Revision 4 lifts offending template-haskell bound
  uuid-types = jailbreakWhileRevision 3 super.uuid-types;
  # Revision 1 lifts offending base bound
  quickcheck-instances = jailbreakWhileRevision 0 super.quickcheck-instances;
  # Revision 1 lifts offending base bound
  generically = jailbreakWhileRevision 0 super.generically;
  # Revision 3 lifts offending template-haskell bound
  hackage-security = jailbreakWhileRevision 2 super.hackage-security;
  # Revision 6 lifts offending base bound
  parallel = jailbreakWhileRevision 5 super.parallel;

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

  # Test suite doesn't compile with base-4.18 / GHC 9.6
  # https://github.com/dreixel/syb/issues/40
  syb = dontCheck super.syb;
}
