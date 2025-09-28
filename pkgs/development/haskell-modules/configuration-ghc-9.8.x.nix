{ pkgs, haskellLib }:

self: super:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs) lib;

  warnAfterVersion =
    ver: pkg:
    lib.warnIf (lib.versionOlder ver
      super.${pkg.pname}.version
    ) "override for haskell.packages.ghc912.${pkg.pname} may no longer be needed" pkg;

in

{

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
  semaphore-compat = null;
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
  xhtml = null;

  #
  # Version upgrades
  #
  megaparsec = doDistribute self.megaparsec_9_7_0;
  ghc-tags = self.ghc-tags_1_8;

  #
  # Jailbreaks
  #
  hashing = doJailbreak super.hashing; # bytestring <0.12
  hevm = appendPatch (pkgs.fetchpatch {
    url = "https://github.com/hellwolf/hevm/commit/338674d1fe22d46ea1e8582b24c224d76d47d0f3.patch";
    name = "release-0.54.2-ghc-9.8.4-patch";
    sha256 = "sha256-Mo65FfP1nh7QTY+oLia22hj4eV2v9hpXlYsrFKljA3E=";
  }) super.hevm;
  HaskellNet-SSL = doJailbreak super.HaskellNet-SSL; # bytestring >=0.9 && <0.12
  inflections = doJailbreak super.inflections; # text >=0.2 && <2.1

  #
  # Test suite issues
  #
  pcre-heavy = dontCheck super.pcre-heavy; # GHC warnings cause the tests to fail

  #
  # Other build fixes
  #

  # 2023-12-23: It needs this to build under ghc-9.6.3.
  #   A factor of 100 is insufficient, 200 seems seems to work.
  hip = appendConfigureFlag "--ghc-options=-fsimpl-tick-factor=200" super.hip;

  # 2025-04-21: "flavor" for GHC 9.8.5 is missing a fix introduced for 9.8.4. See:
  # https://github.com/digital-asset/ghc-lib/pull/571#discussion_r2052684630
  ghc-lib-parser = warnAfterVersion "9.8.5.20250214" (
    overrideCabal {
      postPatch = ''
        substituteInPlace compiler/cbits/genSym.c \
          --replace-fail "HsWord64 u = atomic_inc64" "HsWord64 u = atomic_inc"
      '';
    } super.ghc-lib-parser
  );
}
