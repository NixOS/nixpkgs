{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

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
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_2_2_1;

  # Tests fail because of typechecking changes
  conduit = dontCheck super.conduit;

  # 0.30 introduced support for GHC 9.2.x, so when this assert fails, the whole block can be removed
  cryptonite = assert super.cryptonite.version == "0.29"; appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/cryptonite-0.29.patch";
    sha256 = "1g48lrmqgd88hqvfq3klz7lsrpwrir2v1931myrhh6dy0d9pqj09";
  }) super.cryptonite;

  # cabal-install needs more recent versions of Cabal
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = self.Cabal_3_6_3_0;
  });

  doctest = dontCheck (doJailbreak super.doctest);

  # Tests fail in GHC 9.2
  extra = dontCheck super.extra;

  # Jailbreaks & Version Updates

  # This `doJailbreak` can be removed once we have doctest v0.20
  aeson-diff = assert super.doctest.version == "0.18.2"; doJailbreak super.aeson-diff;

  assoc = doJailbreak super.assoc;
  async = doJailbreak super.async;
  base64-bytestring = doJailbreak super.base64-bytestring;
  base-compat = self.base-compat_0_12_1;
  base-compat-batteries = self.base-compat-batteries_0_12_1;
  binary-instances = doJailbreak super.binary-instances;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  constraints = doJailbreak super.constraints;
  cpphs = overrideCabal (drv: { postPatch = "sed -i -e 's,time >=1.5 && <1.11,time >=1.5 \\&\\& <1.12,' cpphs.cabal";}) super.cpphs;
  data-fix = doJailbreak super.data-fix;
  dbus = super.dbus_1_2_24;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  ghc-byteorder = doJailbreak super.ghc-byteorder;
  ghc-exactprint = overrideCabal (drv: {
    # HACK: ghc-exactprint 1.4.1 is not buildable for GHC < 9.2,
    # but hackage2nix evaluates the cabal file with GHC 8.10.*,
    # causing the build-depends to be skipped. Since the dependency
    # list hasn't changed much since 0.6.4, we can just reuse the
    # normal expression.
    inherit (self.ghc-exactprint_1_5_0) src version;
    revision = null; editedCabalFile = null;
    libraryHaskellDepends = [
      self.fail
      self.ordered-containers
      self.data-default
    ] ++ drv.libraryHaskellDepends or [];
  }) super.ghc-exactprint;
  ghc-lib = self.ghc-lib_9_2_2_20220307;
  ghc-lib-parser = self.ghc-lib-parser_9_2_2_20220307;
  ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_2_0_3;
  hackage-security = doJailbreak super.hackage-security;
  hashable = super.hashable_1_4_0_2;
  hashable-time = doJailbreak super.hashable-time;
  # 1.1.1 introduced support for GHC 9.2.x, so when this assert fails, the jailbreak can be removed
  hedgehog = assert super.hedgehog.version == "1.0.5"; doJailbreak super.hedgehog;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's, <1.1, <1.3,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  indexed-traversable = doJailbreak super.indexed-traversable;
  indexed-traversable-instances = doJailbreak super.indexed-traversable-instances;
  lifted-async = doJailbreak super.lifted-async;
  lukko = doJailbreak super.lukko;
  lzma-conduit = doJailbreak super.lzma-conduit;
  ormolu = self.ormolu_0_4_0_0;
  parallel = doJailbreak super.parallel;
  path = doJailbreak super.path;
  polyparse = overrideCabal (drv: { postPatch = "sed -i -e 's, <0.11, <0.12,' polyparse.cabal"; }) (doJailbreak super.polyparse);
  primitive = doJailbreak super.primitive;
  # https://github.com/protolude/protolude/pull/136
  protolude = appendPatches [
    (pkgs.fetchpatch {
      url = "https://github.com/protolude/protolude/commit/47820a36c25ea6f0c6e44382f7d4f3507358b8e7.diff";
      sha256 = "sha256-PtHx5SyTgqFzI03YVeQD+RqglO6ASMQWSxdpy4ROMDY=";
    })
  ] (doJailbreak super.protolude);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  retrie = doDistribute (dontCheck self.retrie_1_2_0_1);
  singleton-bool = doJailbreak super.singleton-bool;
  servant = doJailbreak super.servant;
  servant-auth = doJailbreak super.servant-auth;
  servant-server = appendPatches [
    # awaiting release
    (pkgs.fetchpatch {
      url = "https://github.com/haskell-servant/servant/commit/61d0d14b5cb01db3d589101b3f17b0178f52e386.diff";
      relative = "servant-server";
      sha256 = "sha256-3lM8xLO8avVRo8oncJR8QLDSWEzOaoCmzgVtyaEBEw8=";
    })
  ] (doJailbreak super.servant-server);
  servant-swagger = doJailbreak super.servant-swagger;
  servant-auth-swagger = doJailbreak super.servant-auth-swagger;
  shelly = doJailbreak super.shelly;
  splitmix = doJailbreak super.splitmix;
  tasty-hspec = doJailbreak super.tasty-hspec;
  th-desugar = self.th-desugar_1_13;
  time-compat = doJailbreak super.time-compat;
  tomland = doJailbreak super.tomland;
  type-equality = doJailbreak super.type-equality;
  unordered-containers = doJailbreak super.unordered-containers;
  vector = dontCheck super.vector;
  vector-binary-instances = doJailbreak super.vector-binary-instances;

  hpack = overrideCabal (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.hpack);

  validity = pkgs.lib.pipe super.validity [
    # head.hackage patch
    (appendPatch (pkgs.fetchpatch {
      url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/9110e6972b5daf085e19cad41f97920d3ddac499/patches/validity-0.12.0.0.patch";
      sha256 = "0hzns596dxvyn8irgi7aflx76wak1qi13chkkvl0055pkgykm08f";
    }))
    # head.hackage ignores test suite
    dontCheck
  ];

  # lens >= 5.1 supports 9.2.1
  lens = doDistribute self.lens_5_1;

  # Syntax error in tests fixed in https://github.com/simonmar/alex/commit/84b29475e057ef744f32a94bc0d3954b84160760
  alex = dontCheck super.alex;

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # 0.17.0 introduced support for GHC 9.2.x, so when this assert fails, the whole block can be removed
  memory = assert super.memory.version == "0.16.0"; appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/memory-0.16.0.patch";
    sha256 = "1kjganx729a6xfgfnrb3z7q6mvnidl042zrsd9n5n5a3i76nl5nl";
  }) (overrideCabal {
    editedCabalFile = null;
    revision = null;
  } super.memory);

  # Use hlint from git for GHC 9.2.1 support
  hlint = self.hlint_3_4;

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # need bytestring >= 0.11 which is only bundled with GHC >= 9.2
  regex-rure = doDistribute (markUnbroken super.regex-rure);
  jacinda = doDistribute super.jacinda;
  some = doJailbreak super.some;
  fourmolu = super.fourmolu_0_6_0_0;
  # hls-fourmolu-plugin in this version has a to strict upper bound of fourmolu <= 0.5.0.0
  hls-fourmolu-plugin = assert super.hls-fourmolu-plugin.version == "1.0.3.0"; doJailbreak super.hls-fourmolu-plugin;
  implicit-hie-cradle = doJailbreak super.implicit-hie-cradle;
  # 1.3 introduced support for GHC 9.2.x, so when this assert fails, the jailbreak can be removed
  hashtables = assert super.hashtables.version == "1.2.4.2"; doJailbreak super.hashtables;
  hiedb = doJailbreak super.hiedb;

  # 2022-02-05: The following plugins don‘t work yet on ghc9.2.
  # Compare: https://haskell-language-server.readthedocs.io/en/latest/supported-versions.html
  haskell-language-server = overrideCabal (old: {libraryHaskellDepends = builtins.filter (x: x != super.hls-tactics-plugin) old.libraryHaskellDepends;})
    (appendConfigureFlags [
    "-f-haddockComments"
    "-f-retrie"
    "-f-splice"
    "-f-tactics"
  ] (super.haskell-language-server.override {
    hls-haddock-comments-plugin = null;
    hls-hlint-plugin = null;
    hls-retrie-plugin = null;
    hls-splice-plugin = null;
  }));

  # https://github.com/fpco/inline-c/pull/131
  inline-c-cpp =
    (if isDarwin then appendConfigureFlags ["--ghc-option=-fcompact-unwind"] else x: x)
    super.inline-c-cpp;
}
