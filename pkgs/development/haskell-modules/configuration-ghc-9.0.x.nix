{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 10.x.
  llvmPackages = pkgs.llvmPackages_10;

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

  # Take the 3.4.x release candidate.
  cabal-install = assert super.cabal-install.version == "3.2.0.0";
                  overrideCabal super.cabal-install (drv: {
    postUnpack = "sourceRoot+=/cabal-install; echo source root reset to $sourceRoot";
    version = "cabal-install-3.4.0.0-rc4";
    editedCabalFile = null;
    src = pkgs.fetchgit {
      url = "git://github.com/haskell/cabal.git";
      rev = "cabal-install-3.4.0.0-rc4";
      sha256 = "049hllk1d8jid9yg70hmcsdgb0n7hm24p39vavllaahfb0qfimrk";
    };
  });

  # Jailbreaks & Version Updates
  async = doJailbreak super.async;
  ChasingBottoms = markBrokenVersion "1.3.1.9" super.ChasingBottoms;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hashable = overrideCabal (doJailbreak (dontCheck super.hashable)) (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; });
  hashable-time = doJailbreak super.hashable-time;
  integer-logarithms = overrideCabal (doJailbreak super.integer-logarithms) (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; });
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak super.primitive_0_7_1_0;
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  split = doJailbreak super.split;
  splitmix = self.splitmix_0_1_0_3;
  tar = doJailbreak super.tar;
  th-abstraction = self.th-abstraction_0_4_0_0;
  time-compat = doJailbreak super.time-compat;
  vector = doJailbreak (dontCheck super.vector);
  zlib = doJailbreak super.zlib;

  # Apply patches from head.hackage.
  alex = appendPatch (dontCheck super.alex) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/alex-3.2.5.patch";
    sha256 = "0q8x49k3jjwyspcmidwr6b84s4y43jbf4wqfxfm6wz8x2dxx6nwh";
  });
  doctest = appendPatch (dontCheck (doJailbreak super.doctest_0_17)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/doctest-0.17.patch";
    sha256 = "16s2jcbk9hsww38i2wzxghbf0zpp5dc35hp6rd2n7d4z5xfavp62";
  });
  generic-deriving = appendPatch (doJailbreak super.generic-deriving) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/generic-deriving-1.13.1.patch";
    sha256 = "0z85kiwhi5p2wiqwyym0y8q8qrcifp125x5vm0n4482lz41kmqds";
  });
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });
  QuickCheck = appendPatch super.QuickCheck_2_14_1 (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/QuickCheck-2.14.1.patch";
    sha256 = "0n89nx95w353h4dzala57gb0y7hx4wbkv5igs89dza50p7ybq9an";
  });
  regex-base = appendPatch (doJailbreak super.regex-base) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/regex-base-0.94.0.0.patch";
    sha256 = "0k5fglbl7nnhn8400c4cpnflxcbj9p3xi5prl9jfmszr31jwdy5d";
  });
  syb = appendPatch (dontCheck super.syb) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/syb-0.7.1.patch";
    sha256 = "1407r8xv6bfnmpbw7glfh4smi76a2fc9pkq300c3d9f575708zqr";
  });

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

}
