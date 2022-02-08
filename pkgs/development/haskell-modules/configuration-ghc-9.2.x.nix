{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

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
  tf-random = overrideCabal {
    doHaddock = !pkgs.stdenv.isAarch64;
  } super.tf-random;

  aeson = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/aeson-1.5.6.0.patch";
    sha256 = "07rk7f0lhgilxvbg2grpl1p5x25wjf9m7a0wqmi2jr0q61p9a0nl";
    # The revision information is newer than that included in the patch
    excludes = ["*.cabal"];
  }) (doJailbreak super.aeson);

  basement = overrideCabal (drv: {
    # This is inside a conditional block so `doJailbreak` doesn't work
    postPatch = "sed -i -e 's,<4.16,<4.17,' basement.cabal";
  }) (appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/basement-0.0.12.patch";
    sha256 = "0c8n2krz827cv87p3vb1vpl3v0k255aysjx9lq44gz3z1dhxd64z";
  }) super.basement);

  # Tests fail because of typechecking changes
  conduit = dontCheck super.conduit;

  cryptonite = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/cryptonite-0.29.patch";
    sha256 = "1g48lrmqgd88hqvfq3klz7lsrpwrir2v1931myrhh6dy0d9pqj09";
  }) super.cryptonite;

  # cabal-install needs more recent versions of Cabal
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = self.Cabal_3_6_2_0;
  });

  doctest = dontCheck (doJailbreak super.doctest_0_18_2);

  # Tests fail in GHC 9.2
  extra = dontCheck super.extra;

  # Jailbreaks & Version Updates
  assoc = doJailbreak super.assoc;
  async = doJailbreak super.async;
  attoparsec = super.attoparsec_0_14_4;
  base64-bytestring = doJailbreak super.base64-bytestring;
  base-compat = self.base-compat_0_12_1;
  base-compat-batteries = self.base-compat-batteries_0_12_1;
  binary-instances = doJailbreak super.binary-instances;
  binary-orphans = super.binary-orphans_1_0_2;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  constraints = doJailbreak super.constraints;
  cpphs = overrideCabal (drv: { postPatch = "sed -i -e 's,time >=1.5 && <1.11,time >=1.5 \\&\\& <1.12,' cpphs.cabal";}) super.cpphs;
  cryptohash-md5 = doJailbreak super.cryptohash-md5;
  cryptohash-sha1 = doJailbreak super.cryptohash-sha1;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  genvalidity = self.genvalidity_1_0_0_1;
  genvalidity-property = self.genvalidity-property_1_0_0_0;
  genvalidity-hspec = self.genvalidity-hspec_1_0_0_0;
  ghc-byteorder = doJailbreak super.ghc-byteorder;
  ghc-exactprint = overrideCabal (drv: {
    # HACK: ghc-exactprint 1.4.1 is not buildable for GHC < 9.2,
    # but hackage2nix evaluates the cabal file with GHC 8.10.*,
    # causing the build-depends to be skipped. Since the dependency
    # list hasn't changed much since 0.6.4, we can just reuse the
    # normal expression.
    inherit (self.ghc-exactprint_1_4_1) src version;
    revision = null; editedCabalFile = null;
    libraryHaskellDepends = [
      self.fail
      self.ordered-containers
      self.data-default
    ] ++ drv.libraryHaskellDepends or [];
  }) super.ghc-exactprint;
  ghc-lib = self.ghc-lib_9_2_1_20220109;
  ghc-lib-parser = self.ghc-lib-parser_9_2_1_20220109;
  ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_2_0_1;
  hackage-security = doJailbreak super.hackage-security;
  hashable = super.hashable_1_4_0_2;
  hashable-time = doJailbreak super.hashable-time_0_3;
  hedgehog = doJailbreak super.hedgehog;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's, <1.1, <1.3,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  indexed-traversable = doJailbreak super.indexed-traversable;
  indexed-traversable-instances = doJailbreak super.indexed-traversable-instances;
  lifted-async = doJailbreak super.lifted-async;
  lukko = doJailbreak super.lukko;
  network = super.network_3_1_2_7;
  ormolu = self.ormolu_0_4_0_0;
  OneTuple = super.OneTuple_0_3_1;
  parallel = doJailbreak super.parallel;
  path = doJailbreak super.path_0_9_2;
  polyparse = overrideCabal (drv: { postPatch = "sed -i -e 's, <0.11, <0.12,' polyparse.cabal"; }) (doJailbreak super.polyparse);
  primitive = doJailbreak super.primitive;
  quickcheck-instances = super.quickcheck-instances_0_3_27;
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  retrie = doDistribute (dontCheck self.retrie_1_2_0_1);
  semialign = super.semialign_1_2_0_1;
  singleton-bool = doJailbreak super.singleton-bool;
  scientific = doJailbreak super.scientific;
  shelly = doJailbreak super.shelly;
  split = doJailbreak super.split;
  splitmix = doJailbreak super.splitmix;
  tar = doJailbreak super.tar;
  tasty-hedgehog = doJailbreak super.tasty-hedgehog;
  tasty-hspec = doJailbreak super.tasty-hspec;
  th-desugar = self.th-desugar_1_13;
  these = doJailbreak super.these;
  time-compat = doJailbreak super.time-compat_1_9_6_1;
  type-equality = doJailbreak super.type-equality;
  unordered-containers = doJailbreak super.unordered-containers;
  vector = doJailbreak (dontCheck super.vector);
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  # Upper bound on `hashable` is too restrictive
  witherable = doJailbreak super.witherable;
  zlib = doJailbreak super.zlib;

  hpack = overrideCabal (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.hpack);

  validity = pkgs.lib.pipe super.validity_0_12_0_0 [
    # head.hackage patch
    (appendPatch (pkgs.fetchpatch {
      url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/9110e6972b5daf085e19cad41f97920d3ddac499/patches/validity-0.12.0.0.patch";
      sha256 = "0hzns596dxvyn8irgi7aflx76wak1qi13chkkvl0055pkgykm08f";
    }))
    # head.hackage ignores test suite
    dontCheck
  ];

  # lens >= 5.1 supports 9.2.1
  lens = super.lens_5_1;

  # Syntax error in tests fixed in https://github.com/simonmar/alex/commit/84b29475e057ef744f32a94bc0d3954b84160760
  alex = dontCheck super.alex;

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # 1.2.1 introduced support for GHC 9.2.1, stackage has 1.2.0
  # The test suite indirectly depends on random, which leads to infinite recursion
  random = dontCheck super.random_1_2_1;

  # 0.16.0 introduced support for GHC 9.0.x, stackage has 0.15.0
  memory = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/memory-0.16.0.patch";
    sha256 = "1kjganx729a6xfgfnrb3z7q6mvnidl042zrsd9n5n5a3i76nl5nl";
  }) (overrideCabal {
    editedCabalFile = null;
    revision = null;
  } super.memory_0_16_0);

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  # Upper bound on `hashable` is too restrictive
  semigroupoids = overrideCabal (drv: { postPatch = "sed -i -e 's,hashable >= 1.2.7.0  && < 1.4,hashable >= 1.2.7.0  \\&\\& < 1.5,' semigroupoids.cabal";}) super.semigroupoids;

  # Tests have a circular dependency on quickcheck-instances
  text-short = dontCheck super.text-short_0_1_5;

  # Use hlint from git for GHC 9.2.1 support
  hlint = doDistribute (
    overrideSrc {
      version = "unstable-2021-12-12";
      src = pkgs.fetchFromGitHub {
        owner = "ndmitchell";
        repo = "hlint";
        rev = "77a9702e10b772a7695c08682cd4f450fd0e9e46";
        sha256 = "0hpp3iw7m7w2abr8vb86gdz3x6c8lj119zxln933k90ia7bmk8jc";
      };
    } (super.hlint_3_3_6.overrideScope (self: super: {
      ghc-lib-parser = self.ghc-lib-parser_9_2_1_20220109;
      ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_2_0_1;
    }))
  );

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # need bytestring >= 0.11 which is only bundled with GHC >= 9.2
  regex-rure = doDistribute (markUnbroken super.regex-rure);
  jacinda = doDistribute super.jacinda;
  some = doJailbreak super.some;
  fourmolu = super.fourmolu_0_5_0_1;
  implicit-hie-cradle = doJailbreak super.implicit-hie-cradle;
  lucid = doJailbreak super.lucid;
  hashtables = doJailbreak super.hashtables;
  primitive-extras = super.primitive-extras_0_10_1_4;
  hiedb = doJailbreak super.hiedb;

  # 2022-02-05: The following plugins don‘t work yet on ghc9.2.
  # Compare: https://haskell-language-server.readthedocs.io/en/latest/supported-versions.html
  haskell-language-server = appendConfigureFlags [
    "-f-alternateNumberFormat"
    "-f-class"
    "-f-eval"
    "-f-haddockComments"
    "-f-hlint"
    "-f-retrie"
    "-f-splice"
    "-f-tactics"
    "-f-brittany"
    "-f-stylish-haskell"
  ] (super.haskell-language-server.override {
    hls-alternate-number-format-plugin = null;
    hls-class-plugin = null;
    hls-eval-plugin = null;
    hls-haddock-comments-plugin = null;
    hls-hlint-plugin = null;
    hls-retrie-plugin = null;
    hls-splice-plugin = null;
    hls-tactics-plugin = null;
    hls-brittany-plugin = null;
    hls-stylish-haskell-plugin = null;
  });
}
