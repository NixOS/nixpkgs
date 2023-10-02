{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
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
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_3_0_0;

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # Jailbreaks & Version Updates

  # For GHC < 9.4, some packages need data-array-byte as an extra dependency
  primitive = addBuildDepends [ self.data-array-byte ] super.primitive;
  hashable = addBuildDepends [
    self.data-array-byte
    self.base-orphans
  ] super.hashable;

  hashable-time = doJailbreak super.hashable-time;
  tuple = addBuildDepend self.base-orphans super.tuple;
  vector-th-unbox = doJailbreak super.vector-th-unbox;

  hls-cabal-plugin = super.hls-cabal-plugin.override {
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  };

  ormolu = self.ormolu_0_5_2_0.override {
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  };

  fourmolu = self.fourmolu_0_10_1_0.override {
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
  };

  doctest = dontCheck super.doctest;
  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  }) (doJailbreak super.language-haskell-extract);

  haskell-language-server = let
    # These aren't included in hackage-packages.nix because hackage2nix is configured for GHC 9.2, under which these plugins aren't supported.
    # See https://github.com/NixOS/nixpkgs/pull/205902 for why we use `self.<package>.scope`
    additionalDeps = with self.haskell-language-server.scope; [
      hls-haddock-comments-plugin
      (unmarkBroken hls-splice-plugin)
      hls-tactics-plugin
    ];
  in addBuildDepends additionalDeps (super.haskell-language-server.overrideScope (lself: lsuper: {
    # Needed for modern ormolu and fourmolu.
    # Apply this here and not in common, because other ghc versions offer different Cabal versions.
    Cabal = lself.Cabal_3_6_3_0;
    hls-overloaded-record-dot-plugin = null;
  }));

  # Needs to use ghc-lib due to incompatible GHC
  ghc-tags = doDistribute (addBuildDepend self.ghc-lib self.ghc-tags_1_5);

  # This package is marked as unbuildable on GHC 9.2, so hackage2nix doesn't include any dependencies.
  # See https://github.com/NixOS/nixpkgs/pull/205902 for why we use `self.<package>.scope`
  hls-haddock-comments-plugin = unmarkBroken (addBuildDepends (with self.hls-haddock-comments-plugin.scope; [
    ghc-exactprint ghcide hls-plugin-api hls-refactor-plugin lsp-types unordered-containers
  ]) super.hls-haddock-comments-plugin);

  hls-tactics-plugin = unmarkBroken (addBuildDepends (with self.hls-tactics-plugin.scope; [
    aeson extra fingertree generic-lens ghc-exactprint ghc-source-gen ghcide
    hls-graph hls-plugin-api hls-refactor-plugin hyphenation lens lsp megaparsec
    parser-combinators prettyprinter refinery retrie syb unagi-chan unordered-containers
  ]) super.hls-tactics-plugin);

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

  # 2021-09-18: https://github.com/haskell/haskell-language-server/issues/2206
  # Restrictive upper bound on ormolu
  hls-ormolu-plugin = doJailbreak super.hls-ormolu-plugin;

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

  hls-hlint-plugin = super.hls-hlint-plugin.override {
    inherit (self) apply-refact;
  };

  # Needs OneTuple for ghc < 9.2
  binary-orphans = addBuildDepends [ self.OneTuple ] super.binary-orphans;

  # Requires GHC < 9.4
  ghc-source-gen = doDistribute (unmarkBroken super.ghc-source-gen);
}
