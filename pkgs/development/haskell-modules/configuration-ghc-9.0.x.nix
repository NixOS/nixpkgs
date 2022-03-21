{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

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

  # cabal-install needs more recent versions of Cabal and base16-bytestring.
  cabal-install = (doJailbreak super.cabal-install).overrideScope (self: super: {
    Cabal = self.Cabal_3_6_2_0;
  });

  # Jailbreaks & Version Updates
  async = doJailbreak super.async;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hackage-security = doJailbreak super.hackage-security;
  hashable = overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; }) (doJailbreak (dontCheck super.hashable));
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; }) (doJailbreak super.HTTP);
  integer-logarithms = overrideCabal (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; }) (doJailbreak super.integer-logarithms);
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak (dontCheck super.primitive);
  primitive-extras = doDistribute (self.primitive-extras_0_10_1_4);
  regex-posix = doJailbreak super.regex-posix;
  resolv = doJailbreak super.resolv;
  singleton-bool = doJailbreak super.singleton-bool;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  time-compat = doJailbreak super.time-compat;
  vector = doJailbreak (dontCheck super.vector);
  vector-binary-instances = doJailbreak super.vector-binary-instances;
  vector-th-unbox = doJailbreak super.vector-th-unbox;
  zlib = doJailbreak super.zlib;
  weeder = self.weeder_2_3_0;
  generic-lens-core = self.generic-lens-core_2_2_1_0;
  generic-lens = self.generic-lens_2_2_1_0;
  th-desugar = self.th-desugar_1_13;
  # 2021-11-08: Fixed in autoapply-0.4.2
  autoapply = doJailbreak self.autoapply_0_4_1_1;

  # Doesn't allow Dhall 1.39.*; forbids lens 5.1
  weeder_2_3_0 = doJailbreak (super.weeder_2_3_0.override {
    dhall = self.dhall_1_40_2;
  });

  # Upstream also disables test for GHC 9: https://github.com/kcsongor/generic-lens/pull/130
  generic-lens_2_2_1_0 = dontCheck super.generic-lens_2_2_1_0;

  # Apply patches from head.hackage.
  doctest = dontCheck (doJailbreak super.doctest_0_18_2);
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  }) (doJailbreak super.language-haskell-extract);

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite seems pretty broken.
  base64-bytestring = dontCheck super.base64-bytestring;

  # 5 introduced support for GHC 9.0.x, but hasn't landed in stackage yet
  lens = super.lens_5_1;

  # 0.16.0 introduced support for GHC 9.0.x, stackage has 0.15.0
  memory = super.memory_0_16_0;

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  # Hlint needs >= 3.3.4 for ghc 9 support.
  hlint = doDistribute super.hlint_3_3_6;

  # 2021-09-18: ghc-api-compat and ghc-lib-* need >= 9.0.x versions for hls and hlint
  ghc-api-compat = doDistribute super.ghc-api-compat_9_0_1;
  ghc-lib-parser = self.ghc-lib-parser_9_0_2_20211226;
  ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_0_0_6;
  ghc-lib = self.ghc-lib_9_0_2_20211226;

  # 2021-09-18: Need semialign >= 1.2 for correct bounds
  semialign = super.semialign_1_2_0_1;

  # 2021-09-18: cabal2nix does not detect the need for ghc-api-compat.
  hiedb = overrideCabal (old: {
    libraryHaskellDepends = old.libraryHaskellDepends ++ [self.ghc-api-compat];
  }) super.hiedb;

  # 2021-09-18: Need path >= 0.9.0 for ghc 9 compat
  path = self.path_0_9_0;
  # 2021-09-18: Need ormolu >= 0.3.0.0 for ghc 9 compat
  ormolu = doDistribute self.ormolu_0_3_1_0;
  # 2021-09-18: https://github.com/haskell/haskell-language-server/issues/2206
  # Restrictive upper bound on ormolu
  hls-ormolu-plugin = doJailbreak super.hls-ormolu-plugin;

  # Too strict bounds on base
  # https://github.com/lspitzner/multistate/issues/9
  multistate = doJailbreak super.multistate;
  # https://github.com/lspitzner/butcher/issues/7
  butcher = doJailbreak super.butcher;
  # Fixes a bug triggered on GHC 9.0.1
  text-short = self.text-short_0_1_5;

  fourmolu = doJailbreak self.fourmolu_0_4_0_0;

  # 2022-02-05: The following plugins don‘t work yet on ghc9.
  # Compare: https://haskell-language-server.readthedocs.io/en/latest/supported-versions.html
  haskell-language-server = appendConfigureFlags [
    "-f-brittany"
    "-f-stylishhaskell"
  ] (super.haskell-language-server.override {
    hls-stylish-haskell-plugin = null; # No upstream support
    hls-brittany-plugin = null; # Dependencies don't build with 9.0.1
  });
}
