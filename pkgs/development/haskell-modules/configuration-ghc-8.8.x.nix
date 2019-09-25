{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 7.x.
  llvmPackages = pkgs.llvmPackages_7;

  # Disable GHC 8.8.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
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

  # Ignore overly restrictive upper version bounds.
  aeson-diff = doJailbreak super.aeson-diff;
  async = doJailbreak super.async;
  cabal-install = doJailbreak super.cabal-install;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  cryptohash-sha256 = doJailbreak super.cryptohash-sha256;
  Diff = dontCheck super.Diff;
  doctest = doJailbreak super.doctest;
  hashable = doJailbreak super.hashable;
  hashable-time = doJailbreak super.hashable-time;
  hledger-lib = doJailbreak super.hledger-lib;  # base >=4.8 && <4.13, easytest >=0.2.1 && <0.3
  integer-logarithms = doJailbreak super.integer-logarithms;
  lucid = doJailbreak super.lucid;
  parallel = doJailbreak super.parallel;
  quickcheck-instances = doJailbreak super.quickcheck-instances;
  setlocale = doJailbreak super.setlocale;
  split = doJailbreak super.split;
  system-fileio = doJailbreak super.system-fileio;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  tasty-hedgehog = doJailbreak super.tasty-hedgehog;
  test-framework = doJailbreak super.test-framework;
  th-expand-syns = doJailbreak super.th-expand-syns;

  # These packages don't work and need patching and/or an update.
  primitive = overrideSrc (doJailbreak super.primitive) {
    version = "20180530-git";
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "primitive";
      rev = "97964182881aa0419546e0bb188b2d17e4468324";
      sha256 = "1p1pinca33vd10iy7hl20c1fc99vharcgcai6z3ngqbq50k2pd3q";
    };
  };
  vector-th-unbox = appendPatch (doJailbreak super.vector-th-unbox) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/vector-th-unbox-0.2.1.6.patch";
    sha256 = "0169yf9ms1g5mmkc5l6hpffzm34zdrqdng4df02nbdmfgba45h19";
  });
  regex-base = overrideCabal (appendPatch super.regex-base (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-base-0.93.2.patch";
    sha256 = "01d1plrdx6hcspwn2h6y9pyi5366qk926vb5cl5qcl6x4m23l6y1";
  })) (drv: {
    preConfigure = "sed -i -e 's/base >=4 && < 4.13,/base,/' regex-base.cabal";
  });
  regex-posix = appendPatch super.regex-posix (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-posix-0.95.2.patch";
    sha256 = "006yli58jpqp786zm1xlncjsilc38iv3a09r4pv94l587sdzasd2";
  });
  optparse-applicative = appendPatch (doJailbreak super.optparse-applicative) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/optparse-applicative-0.14.3.0.patch";
    sha256 = "068sjj98jqiq3h8h03mg4w2pa11q8lxkx2i4lmxivq77xyhlwq3y";
  });
  hackage-security = appendPatch (doJailbreak super.hackage-security) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/hackage-security-0.5.3.0.patch";
    sha256 = "0l8x0pbsn18fj5ak5q0g5rva4xw1s9yc4d86a1pfyaz467b9i5a4";
  });
  hedgehog = appendPatch (doJailbreak super.hedgehog) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/master/patches/hedgehog-1.0.patch";
    sha256 = "16gadh1hb74jqvzc9c893sffb1y2vjglblyrqjwp7xfhccq7g8yw";
  });
  regex-tdfa = appendPatch super.regex-tdfa (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-tdfa-1.2.3.1.patch";
    sha256 = "1lhas4s2ms666prb475gaw2bqw1v4y8cxi66sy20j727sx7ppjs7";
  });
  socks = appendPatch (doJailbreak super.socks) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/socks-0.6.0.patch";
    sha256 = "1dsqmx0sw62x4glh43c0sbizd2y00v5xybiqadn96v6pmfrap5cp";
  });
  polyparse = appendPatch (doJailbreak super.polyparse) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/polyparse-1.12.1.patch";
    sha256 = "01b2gnsq0x4fd9na8zpk6pajym55mbz64hgzawlwxdw0y6681kr5";
  });
  foundation = dontCheck super.foundation;
  chell = overrideCabal (doJailbreak super.chell) (_drv: {
    broken = false;
  });
  haskell-src-meta = appendPatch (dontCheck (doJailbreak super.haskell-src-meta)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/master/patches/haskell-src-meta-0.8.3.patch";
    sha256 = "1asl932mibr5y057xx8v1a7n3qy87lcnclsfh8pbxq1m3iwjkxy8";
  });
  asn1-encoding = appendPatch (dontCheck (doJailbreak super.asn1-encoding)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/master/patches/asn1-encoding-0.9.5.patch";
    sha256 = "0a3159rnaw6shjzdm46799crd4pxh33s23qy51xa7z6nv5q8wsb5";
  });
  vault = dontHaddock super.vault;
  monad-par = dontCheck super.monad-par;   # test suite does not compile in monad-par-0.3.4.8

  # TODO dont fetch patch if https://github.com/simonmar/alex/issues/140 is resolved
  alex = appendPatch super.alex (pkgs.fetchpatch {
    url = "https://github.com/simonmar/alex/commit/deaae6eddef5186bfd0e42e2c3ced39e26afa4d6.patch";
    sha256 = "1v40gmnw4lqyk271wngdwz8whpfdhmza58srbkka8icwwwrck3l5";
  });

  # don't use obsolete "defaultUserHooks" in Setup.hs
  X11 = appendPatch super.X11 (pkgs.fetchpatch {
    url = "https://github.com/xmonad/X11/commit/8d817617afa1b54e6c50a9cc552dc1c0804c1794.patch";
    sha256 = "0zsgzn0nvdxvqi5z0za3gzlhql2x5d5cr0kkr19j5c67fy177w6b";
  });

  # https://github.com/sol/hpack/issues/371
  hpack = appendPatch super.hpack (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/master/patches/hpack-0.32.0.patch";
    sha256 = "11ccl9f7vwbf5cpzknlyvrwgkzpajk4vq9jk9yb5f9la9ggwb244";
  });

  # Upstream ships a broken Setup.hs file.
  csv = overrideCabal super.csv (drv: { prePatch = "rm Setup.hs"; });

  # mark broken packages
  bencode = markBrokenVersion "0.6.0.0" super.bencode;
  easytest = markBroken super.easytest;
  easytest_0_3 = markBroken super.easytest_0_3;
  haskell-src = markBrokenVersion "1.0.3.0" super.haskell-src;

  # use latest version to fix the build
  hackage-db = self.hackage-db_2_1_0;
  lens = self.lens_4_18_1;
  memory = self.memory_0_15_0;
  microlens = self.microlens_0_4_11_2;
  shelly = self.shelly_1_9_0;
  string-qq = self.string-qq_0_0_4;
  tls = self.tls_1_5_1;
  xmonad-contrib = self.xmonad-contrib_0_16;

}
