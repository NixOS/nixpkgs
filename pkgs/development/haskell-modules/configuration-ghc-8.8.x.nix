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
  chell = doJailbreak super.chell;
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
  # TODO: remove when upstream accepts https://github.com/snapframework/io-streams-haproxy/pull/17
  io-streams-haproxy = doJailbreak super.io-streams-haproxy; # base >=4.5 && <4.13

  # use latest version to fix the build
  generics-sop = self.generics-sop_0_5_0_0;
  hackage-db = self.hackage-db_2_1_0;
  lens = self.lens_4_18_1;
  memory = self.memory_0_15_0;
  microlens = self.microlens_0_4_11_2;
  optparse-applicative = self.optparse-applicative_0_15_1_0;
  primitive = dontCheck super.primitive_0_7_0_0;  # evaluating the test suite gives an infinite recursion
  regex-base = self.regex-base_0_94_0_0;
  regex-pcre-builtin = self.regex-pcre-builtin_0_95_1_1_8_43;
  regex-posix = self.regex-posix_0_96_0_0;
  regex-tdfa = self.regex-tdfa_1_3_0;
  shelly = self.shelly_1_9_0;
  sop-core = self.sop-core_0_5_0_0;
  tls = self.tls_1_5_2;
  xmonad-contrib = self.xmonad-contrib_0_16;

  # These packages don't work and need patching and/or an update.
  hackage-security = appendPatch (doJailbreak super.hackage-security) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/hackage-security-0.5.3.0.patch";
    sha256 = "0l8x0pbsn18fj5ak5q0g5rva4xw1s9yc4d86a1pfyaz467b9i5a4";
  });
  polyparse = appendPatch (doJailbreak super.polyparse) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/polyparse-1.12.1.patch";
    sha256 = "01b2gnsq0x4fd9na8zpk6pajym55mbz64hgzawlwxdw0y6681kr5";
  });
  foundation = dontCheck super.foundation;
  haskell-src-meta = appendPatch (dontCheck (doJailbreak super.haskell-src-meta)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/master/patches/haskell-src-meta-0.8.3.patch";
    sha256 = "1asl932mibr5y057xx8v1a7n3qy87lcnclsfh8pbxq1m3iwjkxy8";
  });
  vault = dontHaddock super.vault;
  monad-par = dontCheck super.monad-par;   # test suite does not compile in monad-par-0.3.4.8

  # TODO dont fetch patch if https://github.com/simonmar/alex/issues/140 is resolved
  alex = appendPatch super.alex (pkgs.fetchpatch {
    url = "https://github.com/simonmar/alex/commit/deaae6eddef5186bfd0e42e2c3ced39e26afa4d6.patch";
    sha256 = "1v40gmnw4lqyk271wngdwz8whpfdhmza58srbkka8icwwwrck3l5";
  });

  # Upstream ships a broken Setup.hs file.
  csv = overrideCabal super.csv (drv: { prePatch = "rm Setup.hs"; });

  # mark broken packages
  bencode = markBrokenVersion "0.6.0.0" super.bencode;
  easytest = markBroken super.easytest;
  easytest_0_3 = markBroken super.easytest_0_3;
  haskell-src = markBrokenVersion "1.0.3.0" super.haskell-src;

}
