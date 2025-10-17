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

  #
  # Hand pick versions that are compatible with ghc 9.12 and base 4.21
  #

  extensions = doDistribute self.extensions_0_1_0_3;
  ghc-exactprint = doDistribute self.ghc-exactprint_1_12_0_0;

  #
  # Jailbreaks
  #

  large-generics = doJailbreak super.large-generics; # base <4.20
  cpphs = overrideCabal (drv: {
    # jail break manually the conditional dependencies
    postPatch = ''
      sed -i 's/time >=1.5 \&\& <1.13/time >=1.5 \&\& <=1.14/g' cpphs.cabal
    '';
  }) super.cpphs;
  cabal-install-parsers = doJailbreak super.cabal-install-parsers; # base, Cabal-syntax, etc.
  ghc-exactprint_1_12_0_0 = addBuildDepends [
    # somehow buildDepends was missing
    self.Diff
    self.extra
    self.ghc-paths
    self.silently
    self.syb
    self.HUnit
  ] super.ghc-exactprint_1_12_0_0;
  timezone-series = doJailbreak super.timezone-series; # time <1.14
  timezone-olson = doJailbreak super.timezone-olson; # time <1.14
  cabal-plan = doJailbreak super.cabal-plan; # base <4.21
  dbus = doJailbreak super.dbus; # template-haskell <2.23
  xmobar = doJailbreak super.xmobar; # base <4.21

  #
  # Test suite issues
  #

  call-stack = dontCheck super.call-stack; # https://github.com/sol/call-stack/issues/19

  relude = dontCheck super.relude;

  # https://gitlab.haskell.org/ghc/ghc/-/issues/25930
  generic-lens = dontCheck super.generic-lens;

  # Cabal 3.14 regression (incorrect datadir in tests): https://github.com/haskell/cabal/issues/10717
  alex = overrideCabal (drv: {
    preCheck = drv.preCheck or "" + ''
      export alex_datadir="$(pwd)/data"
    '';
  }) super.alex;

  # https://github.com/sjakobi/newtype-generics/pull/28/files
  newtype-generics = warnAfterVersion "0.6.2" (doJailbreak super.newtype-generics);

  # Test failure because of GHC bug:
  #   https://gitlab.haskell.org/ghc/ghc/-/issues/25937
  #   https://github.com/sol/interpolate/issues/20
  interpolate =
    assert super.ghc.version == "9.12.2";
    dontCheck super.interpolate;
}
