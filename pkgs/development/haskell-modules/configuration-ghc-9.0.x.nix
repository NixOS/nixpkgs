{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs) lib;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC 9.0.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
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
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else doDistribute self.xhtml_3000_3_0_0;

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # Jailbreaks & Version Updates

  # For GHC < 9.4, some packages need data-array-byte as an extra dependency
  primitive = addBuildDepends [ self.data-array-byte ] super.primitive;
  # For GHC < 9.2, os-string is not required.
  hashable = addBuildDepends [
    self.data-array-byte
    self.base-orphans
  ] (super.hashable.override {
    os-string = null;
  });

  # Too strict lower bounds on base
  primitive-addr = doJailbreak super.primitive-addr;

  hashable-time = doJailbreak super.hashable-time;
  tuple = addBuildDepend self.base-orphans super.tuple;
  vector-th-unbox = doJailbreak super.vector-th-unbox;

  ormolu = self.ormolu_0_5_2_0.override {
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  };

  stylish-haskell = doJailbreak super.stylish-haskell_0_14_4_0;

  doctest = dontCheck super.doctest;

  haskell-language-server =  throw "haskell-language-server has dropped support for ghc 9.0 in version 2.4.0.0, please use a newer ghc version or an older nixpkgs version";

  # Needs to use ghc-lib due to incompatible GHC
  ghc-tags = doDistribute (addBuildDepend self.ghc-lib self.ghc-tags_1_6);

  # Test suite sometimes segfaults with GHC 9.0.1 and 9.0.2
  # https://github.com/ekmett/reflection/issues/51
  # https://gitlab.haskell.org/ghc/ghc/-/issues/21141
  reflection = dontCheck super.reflection;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  ghc-api-compat = unmarkBroken super.ghc-api-compat;

  # 2021-09-18: cabal2nix does not detect the need for ghc-api-compat.
  hiedb = overrideCabal (old: {
    libraryHaskellDepends = old.libraryHaskellDepends ++ [self.ghc-api-compat];
  }) super.hiedb;

  # https://github.com/lspitzner/butcher/issues/7
  butcher = doJailbreak super.butcher;

  # We use a GHC patch to support the fix for https://github.com/fpco/inline-c/issues/127
  # which means that the upstream cabal file isn't allowed to add the flag.
  inline-c-cpp =
    (if isDarwin then appendConfigureFlags ["--ghc-option=-fcompact-unwind"] else x: x)
    super.inline-c-cpp;

  # 2022-05-31: weeder 2.4.* requires GHC 9.2
  weeder = doDistribute self.weeder_2_3_1;
  # Unnecessarily strict upper bound on lens
  weeder_2_3_1 = doJailbreak (super.weeder_2_3_1.override {
    # weeder < 2.6 only supports algebraic-graphs < 0.7
    # We no longer have matching test deps for algebraic-graphs 0.6.1 in the set
    algebraic-graphs = dontCheck self.algebraic-graphs_0_6_1;
  });

  # Restrictive upper bound on base and containers
  sv2v = doJailbreak super.sv2v;

  # Later versions only support GHC >= 9.2
  ghc-exactprint = self.ghc-exactprint_0_6_4;

  retrie = dontCheck self.retrie_1_1_0_0;

  apply-refact = self.apply-refact_0_9_3_0;

  # Needs OneTuple for ghc < 9.2
  binary-orphans = addBuildDepends [ self.OneTuple ] super.binary-orphans;

  # Requires GHC < 9.4
  ghc-source-gen = doDistribute (unmarkBroken super.ghc-source-gen);

  hspec-megaparsec = super.hspec-megaparsec_2_2_0;

  # No instance for (Show B.Builder) arising from a use of ‘print’
  http-types = dontCheck super.http-types;

  # Packages which need compat library for GHC < 9.6
  inherit
    (lib.mapAttrs
      (_: addBuildDepends [ self.foldable1-classes-compat ])
      super)
    indexed-traversable
    these
  ;
  base-compat-batteries = addBuildDepends [
    self.foldable1-classes-compat
    self.OneTuple
  ] super.base-compat-batteries;
  OneTuple = addBuildDepends [
    self.foldable1-classes-compat
    self.base-orphans
  ] super.OneTuple;
}
