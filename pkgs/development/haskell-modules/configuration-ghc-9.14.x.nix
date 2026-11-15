{ pkgs, haskellLib }:

self: super:

let
  inherit (pkgs) lib;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskell.packages.ghc914.${pkg.pname} may no longer be needed" pkg;

in

with haskellLib;

{
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
  file-io = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haddock-api = null;
  haddock-library = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  template-haskell-lift = null;
  template-haskell-quasiquoter = null;
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
  xhtml = null;
  Win32 = null;

  #
  # Only support GHC 9.14
  #

  scrod = doDistribute (unmarkBroken super.scrod);

  # haskell-debugger only works with ghc 9.14+
  haskell-debugger-view = doDistribute (unmarkBroken super.haskell-debugger-view);
  haskell-debugger = doDistribute (doJailbreak super.haskell-debugger); # hie-bios < 0.18, random >=1.3.1

  #
  # Version upgrades
  #

  ghc-exactprint_1_14_1_0 = addBuildDepends [
    # cabal2nix drops conditional block: impl (ghc >= 9.14)
    self.containers
    self.Diff
    self.directory
    self.filepath
    self.ghc-paths
    self.silently
    self.syb
    self.HUnit
  ] super.ghc-exactprint_1_14_1_0;

  ghc-exactprint = doDistribute self.ghc-exactprint_1_14_1_0;
  ghc-lib = doDistribute self.ghc-lib_9_14_1_20251220;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_14_1_20251220;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_14_2_0;

  # Cabal 3.18 excludes process 1.6.26.1, which ships with GHC 9.14.1.
  # Use a newer process for Cabal 3.18 and for everything in the
  # cabal-install closure that depends on process directly.
  Cabal_3_18_1_0 = super.Cabal_3_18_1_0.override {
    process = self.process_1_6_30_0;
  };
  inherit
    (
      let
        withNewProcess = pkg: pkg.override { process = self.process_1_6_30_0; };
        processOverlay = cself: csuper: {
          echo = withNewProcess csuper.echo;
          edit-distance = withNewProcess csuper.edit-distance;
          hooks-exe = withNewProcess csuper.hooks-exe;
          open-browser = withNewProcess csuper.open-browser;
          # Test suites depend on tasty, which links the GHC-bundled process
          hackage-security = dontCheck csuper.hackage-security;
        };
      in
      {
        cabal-install = (super.cabal-install.overrideScope processOverlay).override {
          process = self.process_1_6_30_0;
          # GHC 9.14 ships semaphore-compat 1.0.0, cabal-install 3.18 needs >= 2.0.1
          semaphore-compat = self.semaphore-compat_2_0_1;
        };
        cabal-install-solver = dontCheck (super.cabal-install-solver.overrideScope processOverlay);
      }
    )
    cabal-install
    cabal-install-solver
    ;

  # hlint does not support GHC 9.14 yet, it requires ghc-lib-parser 9.12
  # https://github.com/ndmitchell/hlint/issues/1672
  hlint = markBroken super.hlint;

  # hoogle only needs the hackage-revdeps library, which works with the
  # Cabal bundled with GHC. Its executables depend on cabal-install 3.18,
  # which uses a newer process than optparse-applicative, so drop them.
  hoogle = super.hoogle.override {
    hackage-revdeps = overrideCabal (drv: {
      isExecutable = false;
      executableHaskellDepends = [ ];
      postPatch = drv.postPatch or "" + ''
        sed -i '/^executable /,$d' hackage-revdeps.cabal
      '';
    }) super.hackage-revdeps;
  };

  ormolu = doDistribute self.ormolu_0_9_0_0;
  fourmolu = doDistribute self.fourmolu_0_20_1_0;

  inherit
    (
      let
        hls_overlay = lself: lsuper: {
          # HLS can't use Cabal 3.18 yet: Cabal 3.18 excludes process 1.6.26.1,
          # so we build it against process 1.6.30.0, but HLS links the ghc
          # library, which depends on the process 1.6.26.1 bundled with GHC.
          # Mixing both process versions in one closure fails. Cabal 3.16 still
          # accepts the bundled process.
          Cabal-syntax = lself.Cabal-syntax_3_16_1_0;
          Cabal = lself.Cabal_3_16_1_0;
          cabal-install = lself.cabal-install_3_16_1_0;
          # hlint does not support GHC 3.14, yet:
          # https://github.com/ndmitchell/hlint/issues/1672
          apply-refact = null;
          hlint = null;
          refact = null;
          # stylish-haskell does not support GHC 9.14, yet:
          # https://github.com/haskell/haskell-language-server/blob/5ce2a847d255ce6f420da49771711a89eee78541/haskell-language-server.cabal#L1544-L1546
          stylish-haskell = null;
        };
      in
      lib.mapAttrs (_: pkg: doDistribute (pkg.overrideScope hls_overlay)) {
        ghcide = super.ghcide;
        haskell-language-server = lib.pipe super.haskell-language-server [
          (disableCabalFlag "hlint")
          (disableCabalFlag "stylishHaskell")
        ];
        hls-plugin-api = super.hls-plugin-api;
      }
    )
    ghcide
    haskell-language-server
    hls-plugin-api
    ;

  #
  # Jailbreaks
  #

  # https://github.com/haskellari/qc-instances/issues/110
  quickcheck-instances = doJailbreak super.quickcheck-instances;
  # https://github.com/well-typed/cborg/issues/373
  cborg = doJailbreak super.cborg;
  serialise = doJailbreak (
    appendPatches [
      # This removes support for older versions of time (think GHC 8.6) and, in doing so,
      # drops a Cabal flag that prevents jailbreak from working
      (pkgs.fetchpatch {
        name = "serialise-no-old-time.patch";
        url = "https://github.com/well-typed/cborg/commit/308afc2795062f847171463958e5e1bbd9c03381.patch";
        hash = "sha256-Gutu9c+houcwAvq2Z+ZQUQbNK+u+OCJRZfKBtx8/V4c=";
        relative = "serialise";
      })
    ] super.serialise
  );

  # https://github.com/maoe/ghc-trace-events/pull/17
  ghc-trace-events = doJailbreak super.ghc-trace-events; # base < 4.22
  # HLS, for some reason, decided to remove the hie-compat library from its tree
  # in https://github.com/haskell/haskell-language-server/pull/4613
  # even though hiedb (a dependency of HLS) unconditionally depends on it
  # for all GHC versions. As a result, no one has updated the base bound
  # of hie-compat to allow building it with GHC 9.14 neither in tree
  # (which no longer exists) nor on Hackage. Instead, HLS is updating their
  # cabal.project: https://github.com/haskell/haskell-language-server/blob/a4cfaa80ca94beded6f01547a161b37be7b33558/cabal.project#L78
  hie-compat = doJailbreak super.hie-compat; # base < 4.22

  # Too strict bound on containers in test suite
  # https://github.com/jaspervdj/blaze-markup/issues/69
  blaze-markup = doJailbreak super.blaze-markup;
  # https://github.com/jaspervdj/blaze-html/issues/151
  blaze-html = doJailbreak super.blaze-html;

  # 2026-09-05: base <4.22
  # https://github.com/mitchellwrosen/tasty-hspec/pull/38
  tasty-hspec = doJailbreak super.tasty-hspec;

  # 2026-09-05: containers <0.8
  # https://github.com/obsidiansystems/dependent-map/issues/59
  dependent-map = doJailbreak super.dependent-map;

  # 2026-11-15: base <4.22, containers <0.8
  cabal-plan = doJailbreak super.cabal-plan;

  # 2026-11-15: containers <0.8
  glib = doJailbreak super.glib;

  # 2026-11-15: containers <0.8
  pango = doJailbreak super.pango;

  # timezone-series defines FormatTime and ParseTime instances, which is no
  # longer possible since time 1.15 hides Data.Time.Format.Internal.
  # https://github.com/haskell/time/issues/297
  # https://github.com/ygale/timezone-series/issues/41
  xmobar = lib.pipe super.xmobar [
    (
      pkg:
      pkg.override {
        timezone-olson = null;
        timezone-series = null;
      }
    )
    (disableCabalFlag "with_datezone")
    doJailbreak # 2026-11-15: base <4.22
  ];

  #
  # Test suite issues
  #

  # Fails to compile with GHC 9.14 https://github.com/snoyberg/mono-traversable/pull/261
  mono-traversable = dontCheck super.mono-traversable;
  # doctests broke with GHC 9.14, something to do with error messages
  # https://github.com/kcsongor/generic-lens/issues/174
  generic-lens = overrideCabal {
    testTargets = [
      "generic-lens-bifunctor"
      "inspection-tests"
      "generic-lens-syb-tree"
    ];
  } super.generic-lens;
}
