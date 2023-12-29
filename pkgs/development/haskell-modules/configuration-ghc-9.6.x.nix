{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs) lib;

  jailbreakWhileRevision = rev:
    overrideCabal (old: {
      jailbreak = assert old.revision or "0" == toString rev; true;
    });
  checkAgainAfter = pkg: ver: msg: act:
    if builtins.compareVersions pkg.version ver <= 0 then act
    else
      builtins.throw "Check if '${msg}' was resolved in ${pkg.pname} ${pkg.version} and update or remove this";
  jailbreakForCurrentVersion = p: v: checkAgainAfter p v "bad bounds" (doJailbreak p);

  # Workaround for a ghc-9.6 issue: https://gitlab.haskell.org/ghc/ghc/-/issues/23392
  disableParallelBuilding = overrideCabal (drv: { enableParallelBuilding = false; });
in

self: super: {
  llvmPackages = lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC core libraries
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
  # terminfo is not built if GHC is a cross compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else self.terminfo_0_4_1_5;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Version deviations from Stackage LTS
  #

  doctest = doDistribute super.doctest_0_22_2;
  http-api-data = doDistribute self.http-api-data_0_6; # allows base >= 4.18
  some = doDistribute self.some_1_0_6;
  th-abstraction = doDistribute self.th-abstraction_0_6_0_0;
  th-desugar = doDistribute self.th-desugar_1_16;
  semigroupoids = doDistribute self.semigroupoids_6_0_0_1;
  bifunctors = doDistribute self.bifunctors_5_6_1;
  base-compat = doDistribute self.base-compat_0_13_1;
  base-compat-batteries = doDistribute self.base-compat-batteries_0_13_1;
  fgl = doDistribute self.fgl_5_8_2_0;

  # Because we bumped the version of th-abstraction above.^
  aeson = doJailbreak super.aeson;
  free = doJailbreak super.free;

  # Because we bumped the version of base-compat above.^
  cabal-plan = unmarkBroken super.cabal-plan;
  cabal-plan-bounds = unmarkBroken super.cabal-plan-bounds;

  # Requires filepath >= 1.4.100.0 <=> GHC >= 9.6
  file-io = unmarkBroken super.file-io;

  # Too strict upper bound on template-haskell
  # https://github.com/mokus0/th-extras/pull/21
  th-extras = doJailbreak super.th-extras;

  ghc-lib = doDistribute self.ghc-lib_9_6_3_20231014;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_6_3_20231014;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_6_0_2;

  # Tests fail due to the newly-build fourmolu not being in PATH
  # https://github.com/fourmolu/fourmolu/issues/231
  fourmolu = dontCheck super.fourmolu_0_14_0_0;
  ormolu = self.generateOptparseApplicativeCompletions [ "ormolu" ] (enableSeparateBinOutput super.ormolu_0_7_2_0);
  hlint = super.hlint_3_6_1;

  # v0.1.6 forbids base >= 4.18
  singleton-bool = doDistribute super.singleton-bool_0_1_7;

  #
  # Too strict bounds without upstream fix
  #

  # Forbids transformers >= 0.6
  quickcheck-classes-base = doJailbreak super.quickcheck-classes-base;
  # Forbids mtl >= 2.3
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  # Forbids base >= 4.18
  cabal-install-solver = doJailbreak super.cabal-install-solver;
  cabal-install = doJailbreak super.cabal-install;

  # Forbids base >= 4.18, fix proposed: https://github.com/sjakobi/newtype-generics/pull/25
  newtype-generics = jailbreakForCurrentVersion super.newtype-generics "0.6.2";

  #
  # Too strict bounds, waiting on Hackage release in nixpkgs
  #

  #
  # Compilation failure workarounds
  #

  # Add support for time 1.10
  # https://github.com/vincenthz/hs-hourglass/pull/56
  hourglass = appendPatches [
      (pkgs.fetchpatch {
        name = "hourglass-pr-56.patch";
        url =
          "https://github.com/vincenthz/hs-hourglass/commit/cfc2a4b01f9993b1b51432f0a95fa6730d9a558a.patch";
        sha256 = "sha256-gntZf7RkaR4qzrhjrXSC69jE44SknPDBmfs4z9rVa5Q=";
      })
    ] (super.hourglass);


  # Test suite doesn't compile with base-4.18 / GHC 9.6
  # https://github.com/dreixel/syb/issues/40
  syb = dontCheck super.syb;

  # Support for template-haskell >= 2.16
  language-haskell-extract = appendPatch (pkgs.fetchpatch {
    url = "https://gitlab.haskell.org/ghc/head.hackage/-/raw/dfd024c9a336c752288ec35879017a43bd7e85a0/patches/language-haskell-extract-0.2.4.patch";
    sha256 = "0w4y3v69nd3yafpml4gr23l94bdhbmx8xky48a59lckmz5x9fgxv";
  }) (doJailbreak super.language-haskell-extract);

  # Patch 0.17.1 for support of mtl-2.3
  xmonad-contrib = appendPatch
    (pkgs.fetchpatch {
      name = "xmonad-contrib-mtl-2.3.patch";
      url = "https://github.com/xmonad/xmonad-contrib/commit/8cb789af39e93edb07f1eee39c87908e0d7c5ee5.patch";
      sha256 = "sha256-ehCvVy0N2Udii/0K79dsRSBP7/i84yMoeyupvO8WQz4=";
    })
    (doJailbreak super.xmonad-contrib);

  # Patch 0.12.0.1 for support of unix-2.8.0.0
  arbtt = appendPatch
    (pkgs.fetchpatch {
      name = "arbtt-unix-2.8.0.0.patch";
      url = "https://github.com/nomeata/arbtt/pull/168/commits/ddaac94395ac50e3d3cd34c133dda4a8e5a3fd6c.patch";
      sha256 = "sha256-5Gmz23f4M+NfgduA5O+9RaPmnneAB/lAlge8MrFpJYs=";
    })
    super.arbtt;

  # 2023-04-03: plugins disabled for hls 1.10.0.0 based on
  #
  haskell-language-server = super.haskell-language-server.override {
      hls-floskell-plugin = null;
    };

  # Newer version of servant required for GHC 9.6
  servant = self.servant_0_20_1;
  servant-server = self.servant-server_0_20;
  servant-client = self.servant-client_0_20;
  servant-client-core = self.servant-client-core_0_20;
  # Select versions compatible with servant_0_20_1
  servant-docs = self.servant-docs_0_13;
  servant-swagger = self.servant-swagger_1_2;
  # Jailbreaks for servant <0.20
  servant-lucid = doJailbreak super.servant-lucid;

  # Jailbreak strict upper bounds: http-api-data <0.6
  servant_0_20_1 = doJailbreak super.servant_0_20_1;
  servant-server_0_20 = doJailbreak super.servant-server_0_20;
  servant-client_0_20 = doJailbreak super.servant-client_0_20;
  servant-client-core_0_20 = doJailbreak super.servant-client-core_0_20;
  # Jailbreak strict upper bounds: doctest <0.22
  servant-swagger_1_2 = doJailbreak super.servant-swagger_1_2;

  lifted-base = dontCheck super.lifted-base;
  hw-fingertree = dontCheck super.hw-fingertree;
  hw-prim = dontCheck (doJailbreak super.hw-prim);
  stm-containers = dontCheck super.stm-containers;
  regex-tdfa = dontCheck super.regex-tdfa;
  rebase = doJailbreak super.rebase_1_20_1_1;
  rerebase = doJailbreak super.rerebase_1_20_1_1;
  hiedb = dontCheck super.hiedb;
  retrie = dontCheck super.retrie;
  # https://github.com/kowainik/relude/issues/436
  relude = dontCheck (doJailbreak super.relude);

  ghc-exactprint = unmarkBroken (addBuildDepends (with self.ghc-exactprint.scope; [
   HUnit Diff data-default extra fail free ghc-paths ordered-containers silently syb
  ]) super.ghc-exactprint_1_7_0_1);

  inherit (pkgs.lib.mapAttrs (_: doJailbreak ) super)
    hls-cabal-plugin
    algebraic-graphs
    co-log-core
    lens
    cryptohash-sha1
    cryptohash-md5
    ghc-trace-events
    tasty-hspec
    constraints-extras
    tree-diff
    implicit-hie-cradle
    focus
    hie-compat
    dbus       # template-haskell >=2.18 && <2.20, transformers <0.6, unix <2.8
    gi-cairo-connector          # mtl <2.3
    haskintex                   # text <2
    lens-family-th              # template-haskell <2.19
    ghc-prof                    # base <4.18
    profiteur                   # vector <0.13
    mfsolve                     # mtl <2.3
    cubicbezier                 # mtl <2.3
    dhall                       # template-haskell <2.20
    env-guard                   # doctest <0.21
    package-version             # doctest <0.21, tasty-hedgehog <1.4
  ;

  # Avoid triggering an issue in ghc-9.6.2
  gi-gtk = disableParallelBuilding super.gi-gtk;

  # Pending text-2.0 support https://github.com/gtk2hs/gtk2hs/issues/327
  gtk = doJailbreak super.gtk;

  # Doctest comments have bogus imports.
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # Fix ghc-9.6.x build errors.
  libmpd = appendPatch
    # https://github.com/vimus/libmpd-haskell/pull/138
    (pkgs.fetchpatch { url = "https://github.com/vimus/libmpd-haskell/compare/95d3b3bab5858d6d1f0e079d0ab7c2d182336acb...5737096a339edc265a663f51ad9d29baee262694.patch";
                       name = "vimus-libmpd-haskell-pull-138.patch";
                       sha256 = "sha256-CvvylXyRmoCoRJP2MzRwL0SBbrEzDGqAjXS+4LsLutQ=";
                     })
    super.libmpd;

  # Apply patch from PR with mtl-2.3 fix.
  ConfigFile = overrideCabal (drv: {
    editedCabalFile = null;
    buildDepends = drv.buildDepends or [] ++ [ self.HUnit ];
    patches = [(pkgs.fetchpatch {
      # https://github.com/jgoerzen/configfile/pull/12
      name = "ConfigFile-pr-12.patch";
      url = "https://github.com/jgoerzen/configfile/compare/d0a2e654be0b73eadbf2a50661d00574ad7b6f87...83ee30b43f74d2b6781269072cf5ed0f0e00012f.patch";
      sha256 = "sha256-b7u9GiIAd2xpOrM0MfILHNb6Nt7070lNRIadn2l3DfQ=";
    })];
  }) super.ConfigFile;

  # The curl executable is required for withApplication tests.
  warp_3_3_30 = addTestToolDepend pkgs.curl super.warp_3_3_30;

  # The NCG backend for aarch64 generates invalid jumps in some situations,
  # the workaround on 9.6 is to revert to the LLVM backend (which is used
  # for these sorts of situations even on 9.2 and 9.4).
  # https://gitlab.haskell.org/ghc/ghc/-/issues/23746#note_525318
  tls = if pkgs.stdenv.hostPlatform.isAarch64 then self.forceLlvmCodegenBackend super.tls else super.tls;
}
