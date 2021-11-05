{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 10.x.
  llvmPackages = pkgs.lib.dontRecurseIntoAttrs pkgs.llvmPackages_10;

  # Disable GHC 9.2.x core libraries.
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

  # Workaround for https://gitlab.haskell.org/ghc/ghc/-/issues/20594
  tf-random = overrideCabal super.tf-random {
    doHaddock = !pkgs.stdenv.isAarch64;
  };

  aeson = appendPatch (doJailbreak super.aeson) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/aeson-1.5.6.0.patch";
    sha256 = "07rk7f0lhgilxvbg2grpl1p5x25wjf9m7a0wqmi2jr0q61p9a0nl";
    # The revision information is newer than that included in the patch
    excludes = ["*.cabal"];
  });

  attoparsec = appendPatch (doJailbreak super.attoparsec_0_14_1) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/attoparsec-0.14.1.patch";
    sha256 = "0nprywmi3i9ih8mcc8afyimrfjr8pbcjxr2ywz9gwdlwdplk21da";
  });

  # 0.12.0 introduces support for 9.2
  base-compat = self.base-compat_0_12_0;
  base-compat-batteries = self.base-compat-batteries_0_12_0;

  basement = overrideCabal (appendPatch super.basement (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/basement-0.0.12.patch";
    sha256 = "0c8n2krz827cv87p3vb1vpl3v0k255aysjx9lq44gz3z1dhxd64z";
  })) (drv: {
    # This is inside a conditional block so `doJailbreak` doesn't work
    postPatch = "sed -i -e 's,<4.16,<4.17,' basement.cabal";
  });

  base16-bytestring = appendPatch super.base16-bytestring (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/base16-bytestring-1.0.1.0.patch";
    sha256 = "19ajai9y04981zfpcdj1nlz44b12gjj4m1ncciijv43mnz82plji";
  });

  # Duplicate Show instances in tests and library cause compiling tests to fail
  blaze-builder = appendPatch (dontCheck super.blaze-builder) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/blaze-builder-0.4.2.1.patch";
    sha256 = "1h5ny3mlng69vwaabl3af8hlv4qi24wfw8s14lw2ksw1yjbgi0j8";
  });

  cereal = appendPatch (doJailbreak super.cereal) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/cereal-0.5.8.1.patch";
    sha256 = "03v4nxwz9y6viaa8anxcmp4zdf2clczv4pf9fqq6lnpplpz5i128";
  });

  # Tests fail because of typechecking changes
  conduit = dontCheck super.conduit;

  constraints = appendPatch (doJailbreak super.constraints) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/constraints-0.13.patch";
    sha256 = "0cr4qzw0fbwy97f3wx0v3mv8yc642ahpfa80kaqrq191232fzzf3";
  });

  cryptonite = appendPatch super.cryptonite (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/cryptonite-0.29.patch";
    sha256 = "1g48lrmqgd88hqvfq3klz7lsrpwrir2v1931myrhh6dy0d9pqj09";
  });

  # cabal-install needs more recent versions of Cabal
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = self.Cabal_3_6_2_0;
  });

  doctest = appendPatch (dontCheck (doJailbreak super.doctest_0_18_1)) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/doctest-0.18.1.patch";
    sha256 = "030kdsk0fg08cgdcjpyv6z8ym1vkkrbd34aacs91y5hqzc9g79y1";
  });

  entropy = appendPatch super.entropy (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/entropy-0.4.1.6.patch";
    sha256 = "0pbbl6m8b3snf9cz6rs0ljmacpsavayfn0s3p67hdcmndy3ndawi";
  });

  # Tests fail in GHC 9.2
  extra = dontCheck super.extra;

  # Jailbreaks & Version Updates
  assoc = doJailbreak super.assoc;
  async = doJailbreak super.async;
  base64-bytestring = doJailbreak super.base64-bytestring;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  cpphs = overrideCabal super.cpphs (drv: { postPatch = "sed -i -e 's,time >=1.5 && <1.11,time >=1.5 \\&\\& <1.12,' cpphs.cabal";});
  cryptohash-md5 = doJailbreak super.cryptohash-md5;
  cryptohash-sha1 = doJailbreak super.cryptohash-sha1;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  ghc-byteorder = doJailbreak super.ghc-byteorder;
  hackage-security = doJailbreak super.hackage-security;
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (doJailbreak super.HTTP) (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; });
  integer-logarithms = overrideCabal (doJailbreak super.integer-logarithms) (drv: { postPatch = "sed -i -e 's, <1.1, <1.3,' integer-logarithms.cabal"; });
  indexed-traversable = doJailbreak super.indexed-traversable;
  lifted-async = doJailbreak super.lifted-async;
  lukko = doJailbreak super.lukko;
  network = super.network_3_1_2_5;
  parallel = doJailbreak super.parallel;
  polyparse = overrideCabal (doJailbreak super.polyparse) (drv: { postPatch = "sed -i -e 's, <0.11, <0.12,' polyparse.cabal"; });
  primitive = doJailbreak super.primitive;
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  scientific = doJailbreak super.scientific;
  shelly = doJailbreak super.shelly;
  split = doJailbreak super.split;
  splitmix = doJailbreak super.splitmix;
  tar = doJailbreak super.tar;
  these = doJailbreak super.these;
  time-compat = doJailbreak super.time-compat;
  type-equality = doJailbreak super.type-equality;
  vector = doJailbreak (dontCheck super.vector);
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  zlib = doJailbreak super.zlib;
  indexed-traversable-instances = doJailbreak super.indexed-traversable-instances;

  hpack = overrideCabal (doJailbreak super.hpack) (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ] ++ drv.testFlags or [];
  });

  # Patch for TH code from head.hackage
  vector-th-unbox = appendPatch (doJailbreak super.vector-th-unbox) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/vector-th-unbox-0.2.1.9.patch";
    sha256 = "02bvvy3hx3cf4y4dr64zl5pjvq8giwk4286j5g1n6k8ikyn2403p";
  });

  # Patch for TH code from head.hackage
  invariant = appendPatch (doJailbreak super.invariant) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/invariant-0.5.4.patch";
    sha256 = "17gg8ck4r6qmlbcbpbnqzksgf5q7i891zs6axfzhas6ajncylxvc";
  });

  # base 4.15 support from head.hackage
  lens = appendPatch (doJailbreak super.lens_5_0_1) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/lens-5.0.1.patch";
    sha256 = "1s8qqg7ymvv94dnfnr1ragx91chh9y7ydc4jx25zn361wbn00pv7";
  });

  semigroupoids = overrideCabal super.semigroupoids (drv: {
    # Patch from head.hackage for base 4.15 compat
    patches = drv.patches or [] ++ [
      (pkgs.fetchpatch {
        url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/semigroupoids-5.3.5.patch";
        sha256 = "0xrn1gv6b2n76522pk2nfp4z69kvp14l2zpif2f8zzz6cwcrx9w8";
      })
    ];
    # acrobatics to make the patch apply
    prePatch = ''
      find . -type f | xargs -L 1 ${pkgs.buildPackages.dos2unix}/bin/dos2unix
    '';
    editedCabalFile = null;
    revision = null;
  });

  # Syntax error in tests fixed in https://github.com/simonmar/alex/commit/84b29475e057ef744f32a94bc0d3954b84160760
  alex = dontCheck super.alex;

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  });

  hashable = super.hashable_1_3_4_1;

  haskell-src-meta = appendPatch (doJailbreak super.haskell-src-meta) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/haskell-src-meta-0.8.7.patch";
    sha256 = "013k8hpxac226j47cdzgdf9a1j91kmm0cvv7n8zwlajbj3y9bzjp";
  });

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # 1.2.1 introduced support for GHC 9.2.1, stackage has 1.2.0
  # The test suite indirectly depends on random, which leads to infinite recursion
  random = dontCheck super.random_1_2_1;

  # 0.16.0 introduced support for GHC 9.0.x, stackage has 0.15.0
  memory = appendPatch super.memory_0_16_0 (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/memory-0.16.0.patch";
    sha256 = "1kjganx729a6xfgfnrb3z7q6mvnidl042zrsd9n5n5a3i76nl5nl";
  });

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  quickcheck-instances = appendPatch (doJailbreak super.quickcheck-instances) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/quickcheck-instances-0.3.25.2.patch";
    sha256 = "0ndnb6wbnhxxwy69jjdpmd7gmmv6asmx1jczwz1hsn921mn1ilnp";
    # `.cabal` revision information has been included in the patch
    excludes = ["*.cabal"];
  });

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  streaming-commons = appendPatch super.streaming-commons (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/streaming-commons-0.2.2.1.patch";
    sha256 = "04wi1jskr3j8ayh88kkx4irvhhgz0i7aj6fblzijy0fygikvidpy";
  });

  # hlint 3.3 needs a ghc-lib-parser newer than the one from stackage
  hlint = super.hlint_3_3_4.overrideScope (self: super: {
    ghc-lib-parser = overrideCabal self.ghc-lib-parser_9_0_1_20210324 {
      doHaddock = false;
    };
    ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_0_0_4;
  });
}
