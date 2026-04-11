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
  # Version upgrades
  #

  parallel = doDistribute self.parallel_3_3_0_0;
  tagged = doDistribute self.tagged_0_8_10;
  unordered-containers = doDistribute self.unordered-containers_0_2_21;

  #
  # Jailbreaks
  #

  primitive = doJailbreak (dontCheck super.primitive); # base <4.22 and a lot of dependencies on packages not yet working.
  splitmix = doJailbreak super.splitmix; # base <4.22

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

  # https://github.com/sjakobi/newtype-generics/pull/28/files
  newtype-generics = warnAfterVersion "0.6.2" (doJailbreak super.newtype-generics);

  #
  # Test suite issues
  #

  # Fails to compile with GHC 9.14 https://github.com/snoyberg/mono-traversable/pull/261
  mono-traversable = dontCheck super.mono-traversable;
}
