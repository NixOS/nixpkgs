{ pkgs, haskellLib }:

self: super:

let
  inherit (pkgs) lib;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskell.packages.ghc912.${pkg.pname} may no longer be needed" pkg;

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
      haskellLib.doDistribute self.terminfo_0_4_1_7;
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

  ghc-exactprint = doDistribute self.ghc-exactprint_1_14_1_0;
  ghc-lib = doDistribute self.ghc-lib_9_14_1_20251220;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_14_1_20251220;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_14_2_0;

  #
  # Jailbreaks
  #

  primitive = doJailbreak (dontCheck super.primitive); # base <4.22 and a lot of dependencies on packages not yet working.
  splitmix = doJailbreak super.splitmix; # base <4.22

  # https://github.com/phadej/boring/issues/48
  boring = doJailbreak super.boring;
  # https://github.com/haskellari/indexed-traversable/issues/49
  indexed-traversable = doJailbreak super.indexed-traversable;
  # https://github.com/haskellari/indexed-traversable/issues/50
  indexed-traversable-instances = doJailbreak super.indexed-traversable-instances;
  # https://github.com/haskellari/these/issues/211
  these = doJailbreak super.these;
  # https://github.com/haskellari/these/issues/207
  semialign = doJailbreak super.semialign;
  # https://github.com/haskellari/time-compat/issues/48
  time-compat = doJailbreak super.time-compat;
  # https://github.com/haskell-hvr/uuid/issues/95
  uuid-types = doJailbreak super.uuid-types;
  # https://github.com/haskellari/qc-instances/issues/110
  quickcheck-instances = doJailbreak super.quickcheck-instances;
  # https://github.com/haskell/aeson/issues/1155
  text-iso8601 = doJailbreak super.text-iso8601;
  aeson = doJailbreak super.aeson;

  # https://github.com/haskell-party/feed/issues/76
  feed = doJailbreak super.feed; # time<1.15, base<4.22

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

  ormolu = doDistribute self.ormolu_0_8_2_0;
  fourmolu = doDistribute self.fourmolu_0_20_1_0;

  #
  # Test suite issues
  #

  # Tests import containers internals which changed in containers-0.8
  # https://github.com/Mikolaj/enummapset/issues/28
  enummapset = appendPatches [
    (pkgs.fetchpatch {
      name = "enummapset-containers-0.8.patch";
      url = "https://github.com/Mikolaj/enummapset/commit/601e862fbf93cf03ed297016920fa0c0110a5e4c.patch";
      hash = "sha256-pxLW78lDB8ieoh0ZnR50NrZNUyTDkMaqzyy3V5PhlBo=";
    })
  ] super.enummapset;

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

  # Too strict bound on containers in test suite
  # https://github.com/jaspervdj/blaze-markup/issues/69
  blaze-markup = doJailbreak super.blaze-markup;
  # https://github.com/jaspervdj/blaze-html/issues/151
  blaze-html = doJailbreak super.blaze-html;

}
