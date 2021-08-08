{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 10.x.
  llvmPackages = pkgs.lib.dontRecurseIntoAttrs pkgs.llvmPackages_10;

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
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install needs more recent versions of Cabal and base16-bytestring.
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = null;
    base16-bytestring = self.base16-bytestring_0_1_1_7;
  });

  # Jailbreaks & Version Updates
  async = doJailbreak super.async;
  ChasingBottoms = markBrokenVersion "1.3.1.9" super.ChasingBottoms;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hackage-security = doJailbreak super.hackage-security;
  hashable = overrideCabal (doJailbreak (dontCheck super.hashable)) (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; });
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (doJailbreak super.HTTP) (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; });
  integer-logarithms = overrideCabal (doJailbreak super.integer-logarithms) (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; });
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak (dontCheck super.primitive);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  time-compat = doJailbreak super.time-compat;
  vector = doJailbreak (dontCheck super.vector);
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  vector-th-unbox = doJailbreak super.vector-th-unbox;
  zlib = doJailbreak super.zlib;

  # Apply patches from head.hackage.
  alex = appendPatch (dontCheck super.alex) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/fe192e12b88b09499d4aff0e562713e820544bd6/patches/alex-3.2.6.patch";
    sha256 = "1rzs764a0nhx002v4fadbys98s6qblw4kx4g46galzjf5f7n2dn4";
  });
  doctest = dontCheck (doJailbreak super.doctest_0_18_1);
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite seems pretty broken.
  base64-bytestring = dontCheck super.base64-bytestring;

  # 5 introduced support for GHC 9.0.x, but hasn't landed in stackage yet
  lens = super.lens_5_0_1;

  # 0.16.0 introduced support for GHC 9.0.x, stackage has 0.15.0
  memory = super.memory_0_16_0;

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  # hlint 3.3 needs a ghc-lib-parser newer than the one from stackage
  hlint = super.hlint_3_3_1.overrideScope (self: super: {
    ghc-lib-parser = overrideCabal self.ghc-lib-parser_9_0_1_20210324 {
      doHaddock = false;
    };
    ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_0_0_4;
  });
}
