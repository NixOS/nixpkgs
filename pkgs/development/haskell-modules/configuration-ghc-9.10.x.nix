{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

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
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version upgrades
  #

  # Upgrade to accommodate new core library versions, where the authors have
  # already made the relevant changes.
  extensions = doDistribute self.extensions_0_1_0_2;
  # Test suite tightens bound on Diff
  fourmolu = dontCheck (doDistribute self.fourmolu_0_17_0_0);
  ghc-lib = doDistribute self.ghc-lib_9_10_1_20250103;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_10_1_20250103;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_10_0_0;
  htree = doDistribute self.htree_0_2_0_0;
  ormolu = doDistribute self.ormolu_0_7_7_0;

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
  floskell = doJailbreak super.floskell; # base <4.20
  spdx = doJailbreak super.spdx; # Cabal-syntax < 3.13
  tasty-coverage = doJailbreak super.tasty-coverage; # base <4.20, filepath <1.5
  tree-diff = doJailbreak super.tree-diff; # base <4.20
  tree-sitter = doJailbreak super.tree-sitter; # containers <0.7, filepath <1.5
  time-compat = doJailbreak super.time-compat; # base <4.20

  bitvec = doJailbreak super.bitvec; # primitive <0.9

  hashable_1_5_0_0 = doJailbreak super.hashable_1_5_0_0; # relax bounds for QuickCheck, tasty, and tasty-quickcheck

  broadcast-chan = doJailbreak super.broadcast-chan; # base <4.19  https://github.com/merijn/broadcast-chan/pull/19

  #
  # Test suite issues
  #
  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19
  primitive-unlifted = dontCheck super.primitive-unlifted; # doesn't compile with primitive ==0.9.*
  hinotify = pkgs.haskell.lib.dontCheck super.hinotify; # https://github.com/kolmodin/hinotify/issues/38

  haskell-language-server = disableCabalFlag "retrie" (disableCabalFlag "hlint" (disableCabalFlag "stylishhaskel" (super.haskell-language-server.override {stylish-haskell = null;retrie = null;apply-refact=null;hlint = null;})));


}
