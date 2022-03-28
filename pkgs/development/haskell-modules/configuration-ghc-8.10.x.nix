{ pkgs, haskellLib }:

with haskellLib;

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
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install needs more recent versions of Cabal and base16-bytestring.
  cabal-install = super.cabal-install.overrideScope (self: super: {
    Cabal = self.Cabal_3_6_3_0;
  });

  # Pick right versions for GHC-specific packages
  ghc-api-compat = doDistribute self.ghc-api-compat_8_10_7;

  # ghc versions which don‘t match the ghc-lib-parser-ex version need the
  # additional dependency to compile successfully.
  ghc-lib-parser-ex = addBuildDepend self.ghc-lib-parser super.ghc-lib-parser-ex;

  # Jailbreak to fix the build.
  base-noprelude = doJailbreak super.base-noprelude;
  unliftio-core = doJailbreak super.unliftio-core;

  # Jailbreaking because monoidal-containers hasn‘t bumped it's base dependency for 8.10.
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
  hnix = generateOptparseApplicativeCompletion "hnix"
    (overrideCabal (drv: {
      # executable is allowed for ghc >= 8.10 and needs repline
      executableHaskellDepends = drv.executableToolDepends or [] ++ [ self.repline ];
    }) super.hnix);

  mime-string = disableOptimization super.mime-string;

  # Older compilers need the latest ghc-lib to build this package.
  hls-hlint-plugin = addBuildDepend self.ghc-lib super.hls-hlint-plugin;

  haskell-language-server = appendConfigureFlags [
      "-f-fourmolu"
      "-f-stylishhaskell"
      "-f-brittany"
      "-f-hlint"
    ]
  (super.haskell-language-server.override {
    # Not buildable on 8.10
    hls-fourmolu-plugin = null;
    # https://github.com/haskell/haskell-language-server/issues/2728
    hls-hlint-plugin = null;
  });

  # ormolu 0.3 requires Cabal == 3.4
  ormolu = super.ormolu_0_2_0_0;

  # weeder 2.3.0 no longer supports GHC 8.10
  weeder = doDistribute (doJailbreak self.weeder_2_2_0);

  # OneTuple needs hashable instead of ghc-prim for GHC < 9
  OneTuple = super.OneTuple.override {
    ghc-prim = self.hashable;
  };

  # Doesn't build with 9.0, see https://github.com/yi-editor/yi/issues/1125
  yi-core = doDistribute (markUnbroken super.yi-core);

  # Temporarily disabled blaze-textual for GHC >= 9.0 causing hackage2nix ignoring it
  # https://github.com/paul-rouse/mysql-simple/blob/872604f87044ff6d1a240d9819a16c2bdf4ed8f5/Database/MySQL/Internal/Blaze.hs#L4-L10
  mysql-simple = addBuildDepends [
    self.blaze-textual
  ] super.mysql-simple;

  taffybar = markUnbroken (doDistribute super.taffybar);
}
