{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC 8.10.x core libraries.
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

  # Additionally depends on OneTuple for GHC < 9.0
  base-compat-batteries = addBuildDepend self.OneTuple super.base-compat-batteries;

  # Pick right versions for GHC-specific packages
  ghc-api-compat = doDistribute (unmarkBroken self.ghc-api-compat_8_10_7);

  # ghc versions which don’t match the ghc-lib-parser-ex version need the
  # additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser super.ghc-lib-parser-ex;

  # Needs to use ghc-lib due to incompatible GHC
  ghc-tags = doDistribute (addBuildDepend self.ghc-lib self.ghc-tags_1_5);

  # Jailbreak to fix the build.
  base-noprelude = doJailbreak super.base-noprelude;
  unliftio-core = doJailbreak super.unliftio-core;

  # Jailbreaking because monoidal-containers hasn’t bumped it's base dependency for 8.10.
  monoidal-containers = doJailbreak super.monoidal-containers;

  # Jailbreak to fix the build.
  brick = doJailbreak super.brick;
  exact-pi = doJailbreak super.exact-pi;
  serialise = doJailbreak super.serialise;
  setlocale = doJailbreak super.setlocale;
  shellmet = doJailbreak super.shellmet;
  shower = doJailbreak super.shower;

  # Apply patch from https://github.com/finnsson/template-helper/issues/12#issuecomment-611795375 to fix the build.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    name = "language-haskell-extract-0.2.4.patch";
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/e48738ee1be774507887a90a0d67ad1319456afc/patches/language-haskell-extract-0.2.4.patch?inline=false";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  }) (doJailbreak super.language-haskell-extract);

  # hnix 0.9.0 does not provide an executable for ghc < 8.10, so define completions here for now.
  hnix = self.generateOptparseApplicativeCompletions [ "hnix" ]
    (overrideCabal (drv: {
      # executable is allowed for ghc >= 8.10 and needs repline
      executableHaskellDepends = drv.executableToolDepends or [] ++ [ self.repline ];
    }) super.hnix);

  haskell-language-server = let
    # These aren't included in hackage-packages.nix because hackage2nix is configured for GHC 9.2, under which these plugins aren't supported.
    # See https://github.com/NixOS/nixpkgs/pull/205902 for why we use `self.<package>.scope`
    additionalDeps = with self.haskell-language-server.scope; [
      hls-brittany-plugin
      hls-haddock-comments-plugin
      (unmarkBroken hls-splice-plugin)
      hls-tactics-plugin
    ];
  in addBuildDepends additionalDeps (super.haskell-language-server.overrideScope (lself: lsuper: {
    Cabal = lself.Cabal_3_6_3_0;
    aeson = lself.aeson_1_5_6_0;
    lens-aeson = lself.lens-aeson_1_1_3;
    lsp-types = doJailbreak lsuper.lsp-types; # Checks require aeson >= 2.0
  }));

  hls-tactics-plugin = unmarkBroken (addBuildDepends (with self.hls-tactics-plugin.scope; [
    aeson extra fingertree generic-lens ghc-exactprint ghc-source-gen ghcide
    hls-graph hls-plugin-api hls-refactor-plugin hyphenation lens lsp megaparsec
    parser-combinators prettyprinter refinery retrie syb unagi-chan unordered-containers
  ]) super.hls-tactics-plugin);

  hls-brittany-plugin =  unmarkBroken (addBuildDepends (with self.hls-brittany-plugin.scope; [
    brittany czipwith extra ghc-exactprint ghcide hls-plugin-api hls-test-utils lens lsp-types
    ]) (super.hls-brittany-plugin.overrideScope (lself: lsuper: {
    brittany = doJailbreak (unmarkBroken lself.brittany_0_13_1_2);
    aeson = lself.aeson_1_5_6_0;
    multistate = unmarkBroken (dontCheck lsuper.multistate);
    lsp-types = doJailbreak lsuper.lsp-types; # Checks require aeson >= 2.0
  })));

  # This package is marked as unbuildable on GHC 9.2, so hackage2nix doesn't include any dependencies.
  # See https://github.com/NixOS/nixpkgs/pull/205902 for why we use `self.<package>.scope`
  hls-haddock-comments-plugin =  unmarkBroken (addBuildDepends (with self.hls-haddock-comments-plugin.scope; [
    ghc-exactprint ghcide hls-plugin-api hls-refactor-plugin lsp-types unordered-containers
  ]) super.hls-haddock-comments-plugin);

  mime-string = disableOptimization super.mime-string;

  # weeder 2.3.0 no longer supports GHC 8.10
  weeder = doDistribute (doJailbreak self.weeder_2_2_0);

  # OneTuple needs hashable instead of ghc-prim for GHC < 9
  OneTuple = super.OneTuple.override {
    ghc-prim = self.hashable;
  };

  hashable = addBuildDepend self.base-orphans super.hashable;

  # Doesn't build with 9.0, see https://github.com/yi-editor/yi/issues/1125
  yi-core = doDistribute (markUnbroken super.yi-core);

  # Temporarily disabled blaze-textual for GHC >= 9.0 causing hackage2nix ignoring it
  # https://github.com/paul-rouse/mysql-simple/blob/872604f87044ff6d1a240d9819a16c2bdf4ed8f5/Database/MySQL/Internal/Blaze.hs#L4-L10
  mysql-simple = addBuildDepends [
    self.blaze-textual
  ] super.mysql-simple;

  taffybar = markUnbroken (doDistribute super.taffybar);

  # https://github.com/fpco/inline-c/issues/127 (recommend to upgrade to Nixpkgs GHC >=9.0)
  inline-c-cpp = (if isDarwin then dontCheck else x: x) super.inline-c-cpp;

  # Depends on OneTuple for GHC < 9.0
  universe-base = addBuildDepends [ self.OneTuple ] super.universe-base;

  # Not possible to build in the main GHC 9.0 package set
  # https://github.com/awakesecurity/spectacle/issues/49
  spectacle = doDistribute (markUnbroken super.spectacle);

  # doctest-parallel dependency requires newer Cabal
  regex-tdfa = dontCheck super.regex-tdfa;

  # Unnecessarily strict lower bound on base
  # https://github.com/mrkkrp/megaparsec/pull/485#issuecomment-1250051823
  megaparsec = doJailbreak super.megaparsec;

  retrie = dontCheck self.retrie_1_1_0_0;

  # Later versions only support GHC >= 9.2
  ghc-exactprint = self.ghc-exactprint_0_6_4;

  apply-refact = self.apply-refact_0_9_3_0;

  hls-hlint-plugin = super.hls-hlint-plugin.override {
    inherit (self) apply-refact;
  };

  # Needs OneTuple for ghc < 9.2
  binary-orphans = addBuildDepends [ self.OneTuple ] super.binary-orphans;
}
