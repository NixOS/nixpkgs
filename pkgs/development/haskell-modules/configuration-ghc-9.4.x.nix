{ pkgs, haskellLib }:

let
  inherit (pkgs) fetchpatch lib;
in

with haskellLib;
self: super: {
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
  terminfo =
    if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then
      null
    else
      doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else doDistribute self.xhtml_3000_4_0_0;

  # Becomes a core package in GHC >= 9.8
  semaphore-compat = doDistribute self.semaphore-compat_1_0_0;

  # Becomes a core package in GHC >= 9.10
  os-string = doDistribute self.os-string_2_0_8;

  # Becomes a core package in GHC >= 9.10, no release compatible with GHC < 9.10 is available
  ghc-internal = null;
  # Become core packages in GHC >= 9.10, but aren't uploaded to Hackage
  ghc-toolchain = null;
  ghc-platform = null;

  # only broken for >= 9.6
  calligraphy = doDistribute (unmarkBroken super.calligraphy);

  # Jailbreaks & Version Updates

  # hashable >= 1.5 needs base >= 4.18
  hashable = self.hashable_1_4_7_0;
  hashable-time = doJailbreak super.hashable-time;
  libmpd = doJailbreak super.libmpd;

  # generically needs base-orphans for 9.4 only
  base-orphans = dontCheck (doDistribute super.base-orphans);
  generically = addBuildDepends [
    self.base-orphans
  ] super.generically;

  # Needs base-orphans for GHC < 9.8 / base < 4.19
  some = addBuildDepend self.base-orphans super.some;

  # the dontHaddock is due to a GHC panic. might be this bug, not sure.
  # https://gitlab.haskell.org/ghc/ghc/-/issues/21619
  hedgehog = dontHaddock super.hedgehog;

  hpack = overrideCabal (drv: {
    # Cabal 3.6 seems to preserve comments when reading, which makes this test fail
    # 2021-10-10: 9.2.1 is not yet supported (also no issue)
    testFlags = [
      "--skip=/Hpack/renderCabalFile/is inverse to readCabalFile/"
    ]
    ++ drv.testFlags or [ ];
  }) (doJailbreak super.hpack);

  # 2022-08-01: Tests are broken on ghc 9.2.4: https://github.com/wz1000/HieDb/issues/46
  hiedb = dontCheck super.hiedb;

  # 2022-10-06: https://gitlab.haskell.org/ghc/ghc/-/issues/22260
  ghc-check = dontHaddock super.ghc-check;

  ghc-tags = doDistribute (doJailbreak self.ghc-tags_1_7); # aeson < 2.2

  # ghc-lib >= 9.8 and friends no longer build with GHC 9.4 since they require semaphore-compat
  ghc-lib-parser = doDistribute (
    self.ghc-lib-parser_9_6_7_20250325.override {
      happy = self.happy_1_20_1_1; # wants happy < 1.21
    }
  );
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_6_0_2;
  ghc-lib = doDistribute (
    self.ghc-lib_9_6_7_20250325.override {
      happy = self.happy_1_20_1_1; # wants happy < 1.21
    }
  );

  # Last version to not depend on file-io and directory-ospath-streaming,
  # which both need unix >= 2.8.
  tar = self.tar_0_6_3_0;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = dontCheck super.ghc-exactprint_1_6_1_3;

  # Too strict upper bound on template-haskell
  # https://github.com/mokus0/th-extras/issues/18
  th-extras = doJailbreak super.th-extras;

  # https://github.com/kowainik/relude/issues/436
  relude = dontCheck super.relude;

  haddock-library = doJailbreak super.haddock-library;
  apply-refact = addBuildDepend self.data-default-class super.apply-refact;
  path = self.path_0_9_5;
  inherit
    (
      let
        hls_overlay = lself: lsuper: {
          Cabal-syntax = lself.Cabal-syntax_3_10_3_0;
          Cabal = lself.Cabal_3_10_3_0;
          extensions = dontCheck (doJailbreak (lself.extensions_0_1_0_1));
        };
      in
      lib.mapAttrs (_: pkg: doDistribute (pkg.overrideScope hls_overlay)) {
        haskell-language-server = allowInconsistentDependencies (
          addBuildDepends [ self.retrie self.floskell ] super.haskell-language-server
        );
        fourmolu = doJailbreak (dontCheck self.fourmolu_0_14_0_0); # ansi-terminal, Diff
        ormolu = doJailbreak self.ormolu_0_7_2_0; # ansi-terminal
        hlint = self.hlint_3_6_1;
        stylish-haskell = self.stylish-haskell_0_14_5_0;
        retrie = doJailbreak (unmarkBroken super.retrie);
        floskell = doJailbreak super.floskell;
      }
    )
    retrie
    floskell
    haskell-language-server
    fourmolu
    ormolu
    hlint
    stylish-haskell
    ;

  # directory-ospath-streaming requires the ospath API in core packages
  # filepath, directory and unix.
  stan = super.stan.override {
    directory-ospath-streaming = null;
  };

  # Packages which need compat library for GHC < 9.6
  inherit (lib.mapAttrs (_: addBuildDepends [ self.foldable1-classes-compat ]) super)
    indexed-traversable
    OneTuple
    these
    ;
  base-compat-batteries = addBuildDepends [
    self.foldable1-classes-compat
    self.OneTuple
  ] super.base-compat-batteries;

  # Tests require nothunks < 0.3 (conflicting with Stackage) for GHC < 9.8
  aeson = dontCheck super.aeson;

  # Too strict lower bound on base
  primitive-addr = doJailbreak super.primitive-addr;
}
