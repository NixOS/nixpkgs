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

  # Jailbreaks!
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  integer-logarithms = overrideCabal (doJailbreak super.integer-logarithms) (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; });
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak super.primitive_0_7_1_0;
  regex-posix = doJailbreak super.regex-posix;
  singleton-bool = doJailbreak super.singleton-bool;
  tar = doJailbreak super.tar;
  th-abstraction = self.th-abstraction_0_4_0_0;
  zlib = doJailbreak super.zlib;
  splitmix = doJailbreak super.splitmix;

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });
  regex-base = appendPatch (doJailbreak super.regex-base) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/regex-base-0.94.0.0.patch";
    sha256 = "0k5fglbl7nnhn8400c4cpnflxcbj9p3xi5prl9jfmszr31jwdy5d";
  });
  syb = appendPatch (dontCheck super.syb) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/syb-0.7.1.patch";
    sha256 = "1407r8xv6bfnmpbw7glfh4smi76a2fc9pkq300c3d9f575708zqr";
  });

}
