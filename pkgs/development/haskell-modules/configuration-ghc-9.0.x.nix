{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 10.x.
  llvmPackages = pkgs.lib.dontRecurseIntoAttrs pkgs.llvmPackages_10;

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
  ChasingBottoms = markBrokenVersion "1.3.1.9" super.ChasingBottoms;
  data-fix = doJailbreak super.data-fix;
  dec = doJailbreak super.dec;
  ed25519 = doJailbreak super.ed25519;
  hackage-security = doJailbreak super.hackage-security;
  hashable = overrideCabal (doJailbreak (dontCheck super.hashable)) (drv: { postPatch = "sed -i -e 's,integer-gmp .*<1.1,integer-gmp < 2,' hashable.cabal"; });
  hashable-time = doJailbreak super.hashable-time;
  HTTP = overrideCabal (doJailbreak super.HTTP) (drv: { postPatch = "sed -i -e 's,! Socket,!Socket,' Network/TCP.hs"; });
  integer-logarithms = overrideCabal (doJailbreak super.integer-logarithms) (drv: { postPatch = "sed -i -e 's,integer-gmp <1.1,integer-gmp < 2,' integer-logarithms.cabal"; });
  lukko = doJailbreak super.lukko;
  parallel = doJailbreak super.parallel;
  primitive = doJailbreak (dontCheck super.primitive);
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
  generic-lens-core = self.generic-lens-core_2_2_0_0;
  generic-lens = self.generic-lens_2_2_0_0;
  th-desugar = self.th-desugar_1_12;
  autoapply = self.autoapply_0_4_1_1;

  # Doesn't allow Dhall 1.39.*
  weeder_2_3_0 = super.weeder_2_3_0.override {
    dhall = self.dhall_1_40_1;
  };

  # Upstream also disables test for GHC 9: https://github.com/kcsongor/generic-lens/pull/130
  generic-lens_2_2_0_0 = dontCheck super.generic-lens_2_2_0_0;

  # Apply patches from head.hackage.
  alex = appendPatch (dontCheck super.alex) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/fe192e12b88b09499d4aff0e562713e820544bd6/patches/alex-3.2.6.patch";
    sha256 = "1rzs764a0nhx002v4fadbys98s6qblw4kx4g46galzjf5f7n2dn4";
  });
  doctest = dontCheck (doJailbreak super.doctest_0_18_1);
  language-haskell-extract = appendPatch (doJailbreak super.language-haskell-extract) (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/master/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0rgzrq0513nlc1vw7nw4km4bcwn4ivxcgi33jly4a7n3c1r32v1f";
  });

  # The test suite depends on ChasingBottoms, which is broken with ghc-9.0.x.
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite seems pretty broken.
  base64-bytestring = dontCheck super.base64-bytestring;

  # 5 introduced support for GHC 9.0.x, but hasn't landed in stackage yet
  lens = super.lens_5_0_1;

  # 0.16.0 introduced support for GHC 9.0.x, stackage has 0.15.0
  memory = super.memory_0_16_0;

  # GHC 9.0.x doesn't like `import Spec (main)` in Main.hs
  # https://github.com/snoyberg/mono-traversable/issues/192
  mono-traversable = dontCheck super.mono-traversable;

  # Disable tests pending resolution of
  # https://github.com/Soostone/retry/issues/71
  retry = dontCheck super.retry;

  # Hlint needs >= 3.3.4 for ghc 9 support.
  hlint = super.hlint_3_3_4;

  # 2021-09-18: ghc-api-compat and ghc-lib-* need >= 9.0.x versions for hls and hlint
  ghc-api-compat = doDistribute super.ghc-api-compat_9_0_1;
  ghc-lib-parser = self.ghc-lib-parser_9_0_1_20210324;
  ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_0_0_4;
  ghc-lib = self.ghc-lib_9_0_1_20210324;

  # 2021-09-18: Need semialign >= 1.2 for correct bounds
  semialign = super.semialign_1_2;

  # Will probably be needed for brittany support
  # https://github.com/lspitzner/czipwith/pull/2
  #czipwith = appendPatch super.czipwith
  #    (pkgs.fetchpatch {
  #      url = "https://github.com/lspitzner/czipwith/commit/b6245884ae83e00dd2b5261762549b37390179f8.patch";
  #      sha256 = "08rpppdldsdwzb09fmn0j55l23pwyls2dyzziw3yjc1cm0j5vic5";
  #    });

  # 2021-09-18: https://github.com/mokus0/th-extras/pull/8
  # Release is missing, but asked for in the above PR.
  th-extras = overrideCabal super.th-extras (old: {
      version = assert old.version == "0.0.0.4"; "unstable-2021-09-18";
      src = pkgs.fetchFromGitHub  {
        owner = "mokus0";
        repo = "th-extras";
        rev = "0d050b24ec5ef37c825b6f28ebd46787191e2a2d";
        sha256 = "045f36yagrigrggvyb96zqmw8y42qjsllhhx2h20q25sk5h44xsd";
      };
      libraryHaskellDepends = old.libraryHaskellDepends ++ [self.th-abstraction];
    });

  # 2021-09-18: GHC 9 compat release is missing
  # Issue: https://github.com/obsidiansystems/dependent-sum/issues/65
  dependent-sum-template = dontCheck (appendPatch super.dependent-sum-template
      (pkgs.fetchpatch {
        url = "https://github.com/obsidiansystems/dependent-sum/commit/8cf4c7fbc3bfa2be475a17bb7c94a1e1e9a830b5.patch";
        sha256 = "02wyy0ciicq2x8lw4xxz3x5i4a550mxfidhm2ihh60ni6am498ff";
        stripLen = 2;
        extraPrefix = "";
      }));

  # 2021-09-18: cabal2nix does not detect the need for ghc-api-compat.
  hiedb = overrideCabal super.hiedb (old: {
    libraryHaskellDepends = old.libraryHaskellDepends ++ [self.ghc-api-compat];
  });

  # 2021-09-18: Need path >= 0.9.0 for ghc 9 compat
  path = self.path_0_9_0;
  # 2021-09-18: Need ormolu >= 0.3.0.0 for ghc 9 compat
  ormolu = doDistribute self.ormolu_0_3_1_0;
  # 2021-09-18: https://github.com/haskell/haskell-language-server/issues/2206
  # Restrictive upper bound on ormolu
  hls-ormolu-plugin = doJailbreak super.hls-ormolu-plugin;

  # 2021-09-18: The following plugins don‘t work yet on ghc9.
  haskell-language-server = appendConfigureFlags (super.haskell-language-server.override {
    hls-tactics-plugin = null; # No upstream support, generic-lens-core fail
    hls-splice-plugin = null; # No upstream support in hls 1.4.0, should be fixed in 1.5
    hls-refine-imports-plugin = null; # same issue es splice-plugin
    hls-class-plugin = null; # No upstream support

    hls-fourmolu-plugin = null; # No upstream support, needs new fourmolu release
    hls-stylish-haskell-plugin = null; # No upstream support
    hls-brittany-plugin = null; # No upstream support, needs new brittany release
  }) [
    "-f-tactic"
    "-f-splice"
    "-f-refineimports"
    "-f-class"

    "-f-fourmolu"
    "-f-brittany"
    "-f-stylishhaskell"
  ];
}
