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
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_2_2_1;

  # Jailbreaks & Version Updates

  # This `doJailbreak` can be removed once the following PR is released to Hackage:
  # https://github.com/thsutton/aeson-diff/pull/58
  aeson-diff = doJailbreak super.aeson-diff;

  async = doJailbreak super.async;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hackage-security = doJailbreak super.hackage-security;
  hashable =
    pkgs.lib.pipe
      super.hashable
      [ (overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; }))
        doJailbreak
        dontCheck
        (addBuildDepend self.base-orphans)
      ];
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak (dontCheck super.primitive);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  time-compat = doJailbreak super.time-compat;
  tuple = addBuildDepend self.base-orphans super.tuple;
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  vector-th-unbox = doJailbreak super.vector-th-unbox;
  zlib = doJailbreak super.zlib;
  # 2021-11-08: Fixed in autoapply-0.4.2
  autoapply = doJailbreak super.autoapply;

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

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite seems pretty broken.
  base64-bytestring = dontCheck super.base64-bytestring;

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

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

  # 2022-05-31: weeder 2.3.0 requires GHC 9.2
  weeder = doDistribute self.weeder_2_3_1;

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
}
