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
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_5;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_2_2_1;

  # Tests fail because of typechecking changes
  conduit = dontCheck super.conduit;

  # cabal-install needs most recent versions of Cabal and Cabal-syntax
  cabal-install = super.cabal-install.overrideScope (self: super: {
    Cabal = self.Cabal_3_8_1_0;
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
    process = self.process_1_6_16_0;
  });
  cabal-install-solver = super.cabal-install-solver.overrideScope (self: super: {
    Cabal = self.Cabal_3_8_1_0;
    Cabal-syntax = self.Cabal-syntax_3_8_1_0;
    process = self.process_1_6_16_0;
  });

  doctest = dontCheck (doJailbreak super.doctest);

  # Tests fail in GHC 9.2
  extra = dontCheck super.extra;

  # Jailbreaks & Version Updates
  assoc = doJailbreak super.assoc;
  async = doJailbreak super.async;
  base64-bytestring = doJailbreak super.base64-bytestring;
  binary-instances = doJailbreak super.binary-instances;
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  constraints = doJailbreak super.constraints;
  cpphs = overrideCabal (drv: { postPatch = "sed -i -e 's,time >=1.5 && <1.11,time >=1.5 \\&\\& <1.12,' cpphs.cabal";}) super.cpphs;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  ghc-byteorder = doJailbreak super.ghc-byteorder;
  ghc-exactprint = overrideCabal (drv: {
    # HACK: ghc-exactprint 1.4.1 is not buildable for GHC < 9.2,
    # but hackage2nix evaluates the cabal file with GHC 8.10.*,
    # causing the build-depends to be skipped. Since the dependency
    # list hasn't changed much since 0.6.4, we can just reuse the
    # normal expression.
    inherit (super.ghc-exactprint) src version;
    revision = null; editedCabalFile = null;
    libraryHaskellDepends = [
      self.fail
      self.ordered-containers
      self.data-default
    ] ++ drv.libraryHaskellDepends or [];
  }) super.ghc-exactprint;
  ghc-lib-parser = doDistribute super.ghc-lib-parser;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_2_1_1;
  hackage-security = doJailbreak super.hackage-security;
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's, <1.1, <1.3,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  indexed-traversable = doJailbreak super.indexed-traversable;
  indexed-traversable-instances = doJailbreak super.indexed-traversable-instances;
  lifted-async = doJailbreak super.lifted-async;
  lukko = doJailbreak super.lukko;
  lzma-conduit = doJailbreak super.lzma-conduit;
  parallel = doJailbreak super.parallel;
  path = doJailbreak super.path;
  polyparse = overrideCabal (drv: { postPatch = "sed -i -e 's, <0.11, <0.12,' polyparse.cabal"; }) (doJailbreak super.polyparse);
  primitive = doJailbreak super.primitive;
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  retrie = dontCheck super.retrie;
  singleton-bool = doJailbreak super.singleton-bool;
  servant = doJailbreak super.servant;
  servant-swagger = doJailbreak super.servant-swagger;

  # Depends on utf8-light which isn't maintained / doesn't support base >= 4.16
  # https://github.com/haskell-infra/hackage-trustees/issues/347
  # https://mail.haskell.org/pipermail/haskell-cafe/2022-October/135613.html
  language-javascript_0_7_0_0 = dontCheck super.language-javascript_0_7_0_0;

  # 2022-09-02: Too strict bounds on lens
  # https://github.com/haskell-servant/servant/pull/1607/files
  servant-docs = doJailbreak super.servant-docs;
  servant-foreign = doJailbreak super.servant-foreign;
  servant-auth = doJailbreak super.servant-auth;
  servant-auth-docs = doJailbreak super.servant-auth-docs;
  servant-auth-server = doJailbreak super.servant-auth-server;
  servant-auth-swagger = doJailbreak super.servant-auth-swagger;
  # 2022-09-02: Too strict bounds on lens
  # https://github.com/haskell-servant/servant-multipart/pull/64
  servant-multipart = doJailbreak super.servant-multipart;

  shelly = doJailbreak super.shelly;
  splitmix = doJailbreak super.splitmix;
  tasty-hspec = doJailbreak super.tasty-hspec;
  th-desugar = self.th-desugar_1_14;
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

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # For -fghc-lib see cabal.project in haskell-language-server.
  stylish-haskell = enableCabalFlag "ghc-lib" super.stylish-haskell;

  # For "ghc-lib" flag see https://github.com/haskell/haskell-language-server/issues/3185#issuecomment-1250264515
  hlint = doDistribute (enableCabalFlag "ghc-lib" super.hlint);

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # need bytestring >= 0.11 which is only bundled with GHC >= 9.2
  regex-rure = doDistribute (markUnbroken super.regex-rure);
  jacinda = doDistribute super.jacinda;
  some = doJailbreak super.some;

  implicit-hie-cradle = doJailbreak super.implicit-hie-cradle;

  # 2022-08-01: Tests are broken on ghc 9.2.4: https://github.com/wz1000/HieDb/issues/46
  hiedb = doJailbreak (dontCheck super.hiedb);

  # 2022-02-05: The following plugins don‘t work yet on ghc9.2.
  # Compare: https://haskell-language-server.readthedocs.io/en/latest/supported-versions.html
  haskell-language-server = super.haskell-language-server.override {
    hls-haddock-comments-plugin = null;
    hls-splice-plugin = null;
    hls-tactics-plugin = null;
  };

  # https://github.com/fpco/inline-c/pull/131
  inline-c-cpp =
    (if isDarwin then appendConfigureFlags ["--ghc-option=-fcompact-unwind"] else x: x)
    super.inline-c-cpp;

  relude = dontCheck super.relude;
  hermes-json = doJailbreak super.hermes-json;
}
