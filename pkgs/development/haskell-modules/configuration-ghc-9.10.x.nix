{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

  disableParallelBuilding = haskellLib.overrideCabal (drv: { enableParallelBuilding = false; });
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
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/23392
  gi-gtk = disableParallelBuilding super.gi-gtk;

  #
  # Version upgrades
  #

  # Upgrade to accommodate new core library versions, where the authors have
  # already made the relevant changes.
  aeson = doDistribute self.aeson_2_2_3_0;
  apply-refact = doDistribute self.apply-refact_0_14_0_0;
  attoparsec-aeson = doDistribute self.attoparsec-aeson_2_2_2_0;
  extensions = doDistribute self.extensions_0_1_0_2;
  fourmolu = doDistribute self.fourmolu_0_16_2_0;
  hashable = doDistribute self.hashable_1_4_7_0;
  integer-conversion = doDistribute self.integer-conversion_0_1_1;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_10_1_20240511;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_10_0_0;
  lens = doDistribute self.lens_5_3_2;
  lukko = doDistribute self.lukko_0_1_2;
  ormolu = doDistribute self.ormolu_0_7_7_0;
  primitive = doDistribute (dontCheck self.primitive_0_9_0_0); # tests introduce a recursive dependency via hspec
  quickcheck-instances = doDistribute self.quickcheck-instances_0_3_31;
  rebase = doDistribute self.rebase_1_21_1;
  rerebase = doDistribute self.rerebase_1_21_1;
  scientific = doDistribute self.scientific_0_3_8_0;
  semirings = doDistribute self.semirings_0_7;
  th-abstraction = doDistribute self.th-abstraction_0_7_0_0;
  uuid-types = doDistribute self.uuid-types_1_0_6;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = doDistribute self.ghc-exactprint_1_9_0_0;
  ghc-exactprint_1_9_0_0 = addBuildDepends [
    self.Diff
    self.extra
    self.ghc-paths
    self.silently
    self.syb
    self.HUnit
  ] super.ghc-exactprint_1_9_0_0;

  #
  # Jailbreaks
  #
  base64 = doJailbreak super.base64; # base <4.20
  commutative-semigroups = doJailbreak super.commutative-semigroups; # base <4.20
  floskell = doJailbreak super.floskell; # base <4.20
  lucid = doJailbreak super.lucid; # base <4.20
  tar = doJailbreak super.tar; # base <4.20
  tree-diff = doJailbreak super.tree-diff; # base <4.20
  time-compat = doJailbreak super.time-compat; # base <4.20

  bitvec = doJailbreak super.bitvec; # primitive <0.9

  apply-refact_0_14_0_0 = doJailbreak super.apply-refact_0_14_0_0; # ghc-exactprint <1.9
  retrie = doJailbreak super.retrie; # base <4.20, ghc<9.9, ghc-exactprint<1.9

  hashable_1_4_7_0 = doJailbreak super.hashable_1_4_7_0; # relax bounds for QuickCheck, tasty, and tasty-quickcheck
  hashable_1_5_0_0 = doJailbreak super.hashable_1_5_0_0; # relax bounds for QuickCheck, tasty, and tasty-quickcheck

  #
  # Test suite issues
  #
  call-stack = dontCheck super.call-stack; # expects the package to be named "main", but we generate a name
  lifted-base = dontCheck super.lifted-base; # doesn't compile with transformers ==0.6.*
  lukko_0_1_2 = dontCheck super.lukko_0_1_2; # doesn't compile with tasty ==1.4.*
  resolv = dontCheck super.resolv; # doesn't compile with filepath ==1.5.*
  primitive-unlifted = dontCheck super.primitive-unlifted; # doesn't compile with primitive ==0.9.*

  haskell-language-server = disableCabalFlag "retrie" (disableCabalFlag "hlint" (disableCabalFlag "stylishhaskel" (super.haskell-language-server.override {stylish-haskell = null;retrie = null;apply-refact=null;hlint = null;})));


}
