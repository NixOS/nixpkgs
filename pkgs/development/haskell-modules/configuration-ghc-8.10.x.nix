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

  # The proper 3.2.0.0 release does not compile with ghc-8.10.1, so we take the
  # hitherto unreleased next version from the '3.2' branch of the upstream git
  # repository for the time being.
  cabal-install = assert super.cabal-install.version == "3.2.0.0";
                  overrideCabal super.cabal-install (drv: {
    postUnpack = "sourceRoot+=/cabal-install; echo source root reset to $sourceRoot";
    version = "3.2.0.0-git";
    editedCabalFile = null;
    src = pkgs.fetchgit {
      url = "git://github.com/haskell/cabal.git";
      rev = "9bd4cc0591616aeae78e17167338371a2542a475";
      sha256 = "005q1shh7vqgykkp72hhmswmrfpz761x0q0jqfnl3wqim4xd9dg0";
    };
  });

  # Deviate from Stackage LTS-15.x to fix the build.
  haddock-library = self.haddock-library_1_9_0;

  # Jailbreak to fix the build.
  async = doJailbreak super.async;
  base-noprelude = doJailbreak super.base-noprelude;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  ed25519 = doJailbreak super.ed25519;
  email-validate = doJailbreak super.email-validate;  # https://github.com/Porges/email-validate-hs/issues/51
  feed = doJailbreak super.feed;  # https://github.com/bergmark/feed/issues/48
  hashable = doJailbreak super.hashable;
  pandoc = doJailbreak super.pandoc;
  parallel = doJailbreak super.parallel;
  regex-base = doJailbreak super.regex-base;
  regex-compat = doJailbreak super.regex-compat;
  regex-pcre-builtin = doJailbreak super.regex-pcre-builtin;
  regex-posix = doJailbreak super.regex-posix;
  regex-tdfa = doJailbreak super.regex-tdfa;
  split = doJailbreak super.split;
  system-fileio = doJailbreak super.system-fileio;
  tar = doJailbreak super.tar;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  tasty-rerun = doJailbreak super.tasty-rerun;  # https://github.com/ocharles/tasty-rerun/issues/18
  unliftio-core = doJailbreak super.unliftio-core;
  vector = doJailbreak super.vector;
  zlib = doJailbreak super.zlib;

  # Use the latest version to fix the build.
  lens = self.lens_4_19_2;
  optics-core = self.optics-core_0_3;
  repline = self.repline_0_3_0_0;
  singletons = self.singletons_2_7;
  th-desugar = self.th-desugar_1_11;

  # `ghc-lib-parser-ex` (see conditionals in its `.cabal` file) does not need
  # the `ghc-lib-parser` dependency on GHC >= 8.8. However, because we have
  # multiple verions of `ghc-lib-parser(-ex)` available, and the default ones
  # are older ones, those older ones will complain. Because we have a newer
  # GHC, we can just set the dependency to `null` as it is not used.
  ghc-lib-parser-ex = super.ghc-lib-parser-ex.override { ghc-lib-parser = null; };

  # Jailbreak to fix the build.
  aeson-diff = doJailbreak super.aeson-diff;
  brick = doJailbreak super.brick;
  cabal-plan = doJailbreak super.cabal-plan;
  cborg = doJailbreak super.cborg;
  cborg-json = doJailbreak super.cborg-json;
  exact-pi = doJailbreak super.exact-pi;
  policeman = doJailbreak super.policeman;
  relude = dontCheck (doJailbreak super.relude);
  serialise = doJailbreak super.serialise;
  setlocale = doJailbreak super.setlocale;
  shellmet = doJailbreak super.shellmet;

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

  # https://github.com/commercialhaskell/pantry/issues/21
  pantry = appendPatch super.pantry (pkgs.fetchpatch {
    name = "add-cabal-3.2.x-support.patch";
    url = "https://patch-diff.githubusercontent.com/raw/commercialhaskell/pantry/pull/22.patch";
    sha256 = "198hsfjsy83s7rp71llf05cwa3vkm74g73djg5p4sk4awm9s6vf2";
    excludes = ["package.yaml"];
  });

}
