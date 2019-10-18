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
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  test-framework = doJailbreak super.test-framework;

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
  haskell-src-exts = appendPatch (doJailbreak super.haskell-src-exts) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/haskell-src-exts-1.21.0.patch";
    sha256 = "0alb28hcsp774c9s73dgrajcb44vgv1xqfg2n5a9y2bpyngqscs3";
  });
  optparse-applicative = appendPatch (doJailbreak super.optparse-applicative) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/optparse-applicative-0.14.3.0.patch";
    sha256 = "068sjj98jqiq3h8h03mg4w2pa11q8lxkx2i4lmxivq77xyhlwq3y";
  });
  hackage-security = appendPatch (doJailbreak super.hackage-security) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/hackage-security-0.5.3.0.patch";
    sha256 = "0l8x0pbsn18fj5ak5q0g5rva4xw1s9yc4d86a1pfyaz467b9i5a4";
  });
  happy = appendPatch super.happy (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/happy-1.19.11.patch";
    sha256 = "16m659kxbq0s87ak2y1pqggfy67yfvcwc0zi3hcphf3v8735xhkk";
  });
  hedgehog = appendPatch super.hedgehog (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/hedgehog-0.6.1.patch";
    sha256 = "04xwznd3lfgracfz68ls6vfm19rhq8fb74r6ii0grpv6cx4rr21i";
  });
  easytest = self.easytest_0_3;
  regex-tdfa = appendPatch super.regex-tdfa (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/regex-tdfa-1.2.3.1.patch";
    sha256 = "1lhas4s2ms666prb475gaw2bqw1v4y8cxi66sy20j727sx7ppjs7";
  });
  attoparsec = appendPatch (doJailbreak super.attoparsec) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/attoparsec-0.13.2.2.patch";
    sha256 = "13i1p5g0xzxnv966nlyb77mfmxvg9jzbym1d36h1ajn045yf4igl";
  });
  cassava = appendPatch super.cassava (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/cassava-0.5.1.0.patch";
    sha256 = "11scwwjp94si90vb8v5yr291g9qwv5l223z8y0g0lc63932bp63g";
  });
  shakespeare = appendPatch super.shakespeare (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/shakespeare-2.0.20.patch";
    sha256 = "1dgx41ylahj4wk8r422aik0d7qdpawdga4gqz905nvlnhqjla58y";
  });
  socks = appendPatch (doJailbreak super.socks) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/socks-0.6.0.patch";
    sha256 = "1dsqmx0sw62x4glh43c0sbizd2y00v5xybiqadn96v6pmfrap5cp";
  });
  lens = appendPatch (doJailbreak super.lens) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/lens-4.17.1.patch";
    sha256 = "0w89ipi6dfkx5vlw4a64hh6fd0bm9hg33mwpghliyyxik5jmilv1";
  });
  polyparse = appendPatch (doJailbreak super.polyparse) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/polyparse-1.12.1.patch";
    sha256 = "01b2gnsq0x4fd9na8zpk6pajym55mbz64hgzawlwxdw0y6681kr5";
  });
  foundation = dontCheck super.foundation;
  memory = overrideCabal (appendPatch super.memory (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/memory-0.14.18.patch";
    sha256 = "16ar8921s3bi31y1az9zgyg0iaxxc2wvvwqjnl11a17p03wi6b29";
  })) (drv: {
    editedCabalFile = null;
    preConfigure = ''
      cp -v ${pkgs.fetchurl {url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/memory-0.14.18.cabal"; sha256 = "1325wny0irnq51rz0f4xgkvm01p6n4z5jid2jgpkhjac8a2sdgwl";}} memory.cabal
    '';
  });
  chell = overrideCabal (doJailbreak super.chell) (_drv: {
    broken = false;
  });
  th-expand-syns = doJailbreak super.th-expand-syns;
  shelly = overrideCabal (appendPatch (doJailbreak super.shelly) (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/shelly-1.8.1.patch";
    sha256 = "1kglbwrr4ra81v9x3bfsk5l6pyl0my2a1zkr3qjjx7acn0dfpgbc";
  })) (drv: {
    editedCabalFile = null;
    preConfigure = ''
      cp -v ${pkgs.fetchurl {url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/shelly-1.8.1.cabal"; sha256 = "0crf0m077wky76f5nav2p9q4fa5q4yhv5l4bq9hd073dzdaywhz0";}} shelly.cabal
      sed -i -e 's/< 1.9,/< 2,/' shelly.cabal # bump time version
    '';
  });
  system-fileio = doJailbreak super.system-fileio;
  haskell-src-meta = appendPatch (dontCheck (doJailbreak super.haskell-src-meta)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/8be3fb8a6779d0317066d501a3b9dffdf6bb06b0/patches/haskell-src-meta-0.8.2.patch";
    sha256 = "146im1amywyl29kcldvgrxpwj22lrpzxysl7vc8rmn3hrq130dyc";
  });
  asn1-encoding = appendPatch (dontCheck (doJailbreak super.asn1-encoding)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/raw/82d0fd9967af0699f0ccb5b38f2f0cbef6ed22de/patches/asn1-encoding-0.9.5.patch";
    sha256 = "0a3159rnaw6shjzdm46799crd4pxh33s23qy51xa7z6nv5q8wsb5";
  });
  tls = self.tls_1_5_1;
  alex = appendPatch (super.alex) (pkgs.fetchpatch {
    url = "https://github.com/simonmar/alex/commit/deaae6eddef5186bfd0e42e2c3ced39e26afa4d6.patch";
    sha256 = "1v40gmnw4lqyk271wngdwz8whpfdhmza58srbkka8icwwwrck3l5";
  });
  connection = doJailbreak super.connection;
}
