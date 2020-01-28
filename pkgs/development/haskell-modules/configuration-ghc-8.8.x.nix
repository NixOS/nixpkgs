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
  snap-server = doJailbreak super.snap-server;
  xmobar = doJailbreak super.xmobar;

  # use latest version to fix the build
  brick = self.brick_0_50_1;
  dbus = self.dbus_1_2_11;
  doctemplates = self.doctemplates_0_8;
  exact-pi = doJailbreak super.exact-pi;
  generics-sop = self.generics-sop_0_5_0_0;
  hackage-db = self.hackage-db_2_1_0;
  haddock-library = self.haddock-library_1_8_0;
  haskell-src-meta = self.haskell-src-meta_0_8_5;
  haskell-src-meta_0_8_5 = dontCheck super.haskell-src-meta_0_8_5;
  HaTeX = self.HaTeX_3_22_0_0;
  HsYAML = self.HsYAML_0_2_1_0;
  json-autotype = doJailbreak super.json-autotype;
  lens = self.lens_4_18_1;
  memory = self.memory_0_15_0;
  microlens = self.microlens_0_4_11_2;
  microlens-ghc = self.microlens-ghc_0_4_11_1;
  microlens-mtl = self.microlens-mtl_0_2_0_1;
  microlens-platform = self.microlens-platform_0_4_0;
  microlens-th = self.microlens-th_0_4_3_2;
  network = self.network_3_1_1_1;
  optparse-applicative = self.optparse-applicative_0_15_1_0;
  pandoc = dontCheck super.pandoc_2_9_1_1;        # https://github.com/jgm/pandoc/issues/6086
  pandoc-types = self.pandoc-types_1_20;
  prettyprinter = self.prettyprinter_1_6_0;
  primitive = dontCheck super.primitive_0_7_0_0;  # evaluating the test suite gives an infinite recursion
  regex-base = self.regex-base_0_94_0_0;
  regex-compat = self.regex-compat_0_95_2_0;
  regex-pcre-builtin = self.regex-pcre-builtin_0_95_1_1_8_43;
  regex-posix = self.regex-posix_0_96_0_0;
  regex-tdfa = self.regex-tdfa_1_3_1_0;
  shelly = self.shelly_1_9_0;
  singletons = self.singletons_2_6;
  skylighting = self.skylighting_0_8_3_2;
  skylighting-core = self.skylighting-core_0_8_3_2;
  sop-core = self.sop-core_0_5_0_0;
  texmath = self.texmath_0_12;
  th-desugar = self.th-desugar_1_10;
  tls = self.tls_1_5_3;
  trifecta = self.trifecta_2_1;
  vty = self.vty_5_26;
  xml-conduit = overrideCabal super.xml-conduit (drv: { version = "1.9.0.0"; sha256 = "1p57v127882rxvvmwjmvnqdmk3x2wg1z4d8y03849h0xaz1vid0w"; });
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
  vault = dontHaddock super.vault;

  # https://github.com/snapframework/snap-core/issues/288
  snap-core = overrideCabal super.snap-core (drv: { prePatch = "substituteInPlace src/Snap/Internal/Core.hs --replace 'fail   = Fail.fail' ''"; });
  # needs a release
  json = overrideCabal super.json (drv: { prePatch = "substituteInPlace json.cabal --replace '4.13' '4.14'"; patches = [(
    pkgs.fetchpatch {
      url = "https://github.com/GaloisInc/json/commit/9d36ca5d865be7e4b2126b68a444b901941d2492.patch";
      sha256 = "0vyi5nbivkqg6zngq7rb3wwcj9043m4hmyk155nrcddl8j2smfzv";
    }
  )]; });

  # Upstream ships a broken Setup.hs file.
  csv = overrideCabal super.csv (drv: { prePatch = "rm Setup.hs"; });

  # mark broken packages
  bencode = markBrokenVersion "0.6.0.0" super.bencode;
  easytest = markBroken super.easytest;
  easytest_0_3 = markBroken super.easytest_0_3;
  haskell-src = markBrokenVersion "1.0.3.0" super.haskell-src;

}
