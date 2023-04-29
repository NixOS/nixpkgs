{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
  checkAgainAfter = pkg: ver: msg: act:
    if builtins.compareVersions pkg.version ver <= 0 then act
    else
      builtins.throw "Check if '${msg}' was resolved in ${pkg.pname} ${pkg.version} and update or remove this";
in

with haskellLib;
self: super: let
  jailbreakForCurrentVersion = p: v: checkAgainAfter p v "bad bounds" (doJailbreak p);
in {
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
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
  system-cxx-std-lib = null;
  template-haskell = null;
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else self.xhtml_3000_2_2_1;

  # Tests fail because of typechecking changes
  conduit = dontCheck super.conduit;

  # consequences of doctest breakage follow:

  ghc-source-gen = checkAgainAfter super.ghc-source-gen "0.4.3.0" "fails to build" (markBroken super.ghc-source-gen);

  haskell-src-meta = doJailbreak super.haskell-src-meta;

  # Tests fail in GHC 9.2
  extra = dontCheck super.extra;

  # Jailbreaks & Version Updates

  aeson = doDistribute self.aeson_2_1_2_1;
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
  ghc-lib = doDistribute self.ghc-lib-parser_9_4_4_20221225;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_4_4_20221225;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_4_0_0;
  hackage-security = doJailbreak super.hackage-security;
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's, <1.1, <1.3,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  lifted-async = doJailbreak super.lifted-async;
  lukko = doJailbreak super.lukko;
  lzma-conduit = doJailbreak super.lzma-conduit;
  parallel = doJailbreak super.parallel;
  path = doJailbreak super.path;
  polyparse = overrideCabal (drv: { postPatch = "sed -i -e 's, <0.11, <0.12,' polyparse.cabal"; }) (doJailbreak super.polyparse);
  primitive = dontCheck (doJailbreak self.primitive_0_7_4_0);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  rope-utf16-splay = doDistribute self.rope-utf16-splay_0_4_0_0;
  shake-cabal = doDistribute self.shake-cabal_0_2_2_3;
  libmpd = doJailbreak super.libmpd;
  generics-sop = doJailbreak super.generics-sop;
  microlens-th = doJailbreak super.microlens-th;
  # generically needs base-orphans for 9.4 only
  base-orphans = dontCheck (doDistribute super.base-orphans);
  generically = addBuildDepend self.base-orphans super.generically;

  # the dontHaddock is due to a GHC panic. might be this bug, not sure.
  # https://gitlab.haskell.org/ghc/ghc/-/issues/21619
  #
  # We need >= 1.1.2 for ghc-9.4 support, but we don't have 1.1.x in
  # hackage-packages.nix
  hedgehog = doDistribute (dontHaddock super.hedgehog_1_2);
  # tasty-hedgehog > 1.3 necessary to work with hedgehog 1.2:
  # https://github.com/qfpl/tasty-hedgehog/pull/63
  tasty-hedgehog = self.tasty-hedgehog_1_4_0_1;

  # https://github.com/dreixel/syb/issues/38
  syb = dontCheck super.syb;

  splitmix = doJailbreak super.splitmix;
  th-desugar = doDistribute self.th-desugar_1_15;
  th-abstraction = doDistribute self.th-abstraction_0_5_0_0;
  time-compat = doJailbreak super.time-compat;
  tomland = doJailbreak super.tomland;
  type-equality = doJailbreak super.type-equality;
  unordered-containers = doJailbreak super.unordered-containers;
  vector-binary-instances = doJailbreak super.vector-binary-instances;

  hpack = overrideCabal (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ] ++ drv.testFlags or [];
  }) (doJailbreak super.hpack);

  lens = doDistribute self.lens_5_2_2;

  # Apply patches from head.hackage.
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  memory = super.memory_0_18_0;

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # need bytestring >= 0.11 which is only bundled with GHC >= 9.2
  regex-rure = doDistribute (markUnbroken super.regex-rure);
  jacinda = doDistribute super.jacinda;
  some = doJailbreak super.some;

  # 2022-08-01: Tests are broken on ghc 9.2.4: https://github.com/wz1000/HieDb/issues/46
  hiedb = dontCheck super.hiedb;

  hlint = self.hlint_3_5;
  hls-hlint-plugin = super.hls-hlint-plugin.override {
    inherit (self) hlint;
  };

  # 2022-10-06: https://gitlab.haskell.org/ghc/ghc/-/issues/22260
  ghc-check = dontHaddock super.ghc-check;

  ghc-exactprint = overrideCabal (drv: {
    libraryHaskellDepends = with self; [ HUnit data-default fail filemanip free ghc-paths ordered-containers silently syb Diff ];
  })
    self.ghc-exactprint_1_6_1_1;

  # needed to build servant
  http-api-data = super.http-api-data_0_5_1;
  attoparsec-iso8601 = super.attoparsec-iso8601_1_1_0_0;

  # requires newer versions to work with GHC 9.4
  swagger2 = dontCheck super.swagger2;
  servant = doJailbreak super.servant;
  servant-server = doJailbreak super.servant-server;
  servant-auth = doJailbreak super.servant-auth;
  servant-auth-swagger = doJailbreak super.servant-auth-swagger;
  servant-swagger = doJailbreak super.servant-swagger;
  servant-client-core = doJailbreak super.servant-client-core;
  servant-client = doJailbreak super.servant-client;
  relude = doJailbreak super.relude;

  # Fixes compilation failure with GHC >= 9.4 on aarch64-* due to an API change
  cborg = appendPatch (pkgs.fetchpatch {
    name = "cborg-support-ghc-9.4.patch";
    url = "https://github.com/well-typed/cborg/pull/304.diff";
    sha256 = "sha256-W4HldlESKOVkTPhz9nkFrvbj9akCOtF1SbIt5eJqtj8=";
    relative = "cborg";
  }) super.cborg;

  ormolu = doDistribute self.ormolu_0_5_3_0;
  # https://github.com/tweag/ormolu/issues/941
  fourmolu = overrideCabal (drv: {
    libraryHaskellDepends = drv.libraryHaskellDepends ++ [ self.file-embed ];
  }) (disableCabalFlag "fixity-th" super.fourmolu_0_10_1_0);

  # Apply workaround for Cabal 3.8 bug https://github.com/haskell/cabal/issues/8455
  # by making `pkg-config --static` happy. Note: Cabal 3.9 is also affected, so
  # the GHC 9.6 configuration may need similar overrides eventually.
  X11-xft = __CabalEagerPkgConfigWorkaround super.X11-xft;
  # Jailbreaks for https://github.com/gtk2hs/gtk2hs/issues/323#issuecomment-1416723309
  glib = __CabalEagerPkgConfigWorkaround (doJailbreak super.glib);
  cairo = __CabalEagerPkgConfigWorkaround (doJailbreak super.cairo);
  pango = __CabalEagerPkgConfigWorkaround (doJailbreak super.pango);

  # The gtk2hs setup hook provided by this package lacks the ppOrdering field that
  # recent versions of Cabal require. This leads to builds like cairo and glib
  # failing during the Setup.hs phase: https://github.com/gtk2hs/gtk2hs/issues/323.
  gtk2hs-buildtools = appendPatch ./patches/gtk2hs-buildtools-fix-ghc-9.4.x.patch super.gtk2hs-buildtools;

  # Pending text-2.0 support https://github.com/gtk2hs/gtk2hs/issues/327
  gtk = doJailbreak super.gtk;
}
