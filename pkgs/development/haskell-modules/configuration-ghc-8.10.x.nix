{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 9.x.
  llvmPackages = pkgs.llvmPackages_9;

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

  # Jailbreak to fix the build.
  async = doJailbreak super.async;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  hashable = doJailbreak super.hashable;
  parallel = doJailbreak super.parallel;
  regex-base = doJailbreak super.regex-base;
  regex-compat = doJailbreak super.regex-compat;
  regex-pcre-builtin = doJailbreak super.regex-pcre-builtin;
  regex-posix = doJailbreak super.regex-posix;
  regex-tdfa = doJailbreak super.regex-tdfa;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  unliftio-core = doJailbreak super.unliftio-core;
  vector = doJailbreak super.vector;
  zlib = doJailbreak super.zlib;

  # Use the latest version to fix the build.
  microlens-th = self.microlens-th_0_4_3_5;
  optics-core = self.optics-core_0_3;
  repline = self.repline_0_3_0_0;
  ghc-lib-parser-ex = self.ghc-lib-parser-ex_8_10_0_4;
  th-desugar = self.th-desugar_1_11;

  # `ghc-lib-parser-ex` (see conditionals in its `.cabal` file) does not need
  # the `ghc-lib-parser` dependency on GHC >= 8.8. However, because we have
  # multiple verions of `ghc-lib-parser(-ex)` available, and the default ones
  # are older ones, those older ones will complain. Because we have a newer
  # GHC, we can just set the dependency to `null` as it is not used.
  ghc-lib-parser-ex_8_10_0_4 = super.ghc-lib-parser-ex_8_10_0_4.override { ghc-lib-parser = null; };

  # Jailbreak to fix the build.
  aeson-diff = doJailbreak super.aeson-diff;
  cborg = doJailbreak super.cborg;
  cborg-json = doJailbreak super.cborg-json;
  exact-pi = doJailbreak super.exact-pi;
  relude = dontCheck (doJailbreak super.relude);
  serialise = doJailbreak super.serialise;
  setlocale = doJailbreak super.setlocale;
  shellmet = doJailbreak super.shellmet;
  brick = doJailbreak super.brick;

  # The shipped Setup.hs file is broken.
  csv = overrideCabal super.csv (drv: { preCompileBuildDriver = "rm Setup.hs"; });

  # Apply patch from https://github.com/finnsson/template-helper/issues/12#issuecomment-611795375 to fix the build.
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    name = "language-haskell-extract-0.2.4.patch";
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/e48738ee1be774507887a90a0d67ad1319456afc/patches/language-haskell-extract-0.2.4.patch?inline=false";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });

  # Only 0.8 is compatible with ghc 8.10 https://hackage.haskell.org/package/apply-refact/changelog
  apply-refact = super.apply-refact_0_8_0_0;
}
