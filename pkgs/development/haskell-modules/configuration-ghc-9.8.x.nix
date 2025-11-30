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
    ) "override for haskell.packages.ghc98.${pkg.pname} may no longer be needed" pkg;

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
  Win32 = null;

  # Becomes a core package in GHC >= 9.10
  os-string = doDistribute self.os-string_2_0_8;

  # Becomes a core package in GHC >= 9.10, no release compatible with GHC < 9.10 is available
  ghc-internal = null;
  # Become core packages in GHC >= 9.10, but aren't uploaded to Hackage
  ghc-toolchain = null;
  ghc-platform = null;

  #
  # Version upgrades
  #
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

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = doDistribute super.ghc-exactprint_1_8_0_0;

  haddock-library = doJailbreak super.haddock-library;
  ghc-lib-parser = doDistribute self.ghc-lib-parser_9_8_5_20250214;
  ghc-lib-parser-ex = doDistribute self.ghc-lib-parser-ex_9_8_0_2;
  inherit
    (
      let
        hls_overlay = lself: lsuper: {
          Cabal-syntax = lself.Cabal-syntax_3_10_3_0;
          Cabal = lself.Cabal_3_10_3_0;
          extensions = dontCheck (doJailbreak lself.extensions_0_1_0_1);
        };
      in
      lib.mapAttrs (_: pkg: doDistribute (pkg.overrideScope hls_overlay)) {
        apply-refact = addBuildDepend self.data-default-class super.apply-refact;
        floskell = doJailbreak super.floskell;
        fourmolu = dontCheck (doJailbreak self.fourmolu_0_15_0_0);
        haskell-language-server = addBuildDepends [
          self.retrie
          self.floskell
          self.markdown-unlit
        ] super.haskell-language-server;
        hls-plugin-api = super.hls-plugin-api;
        hlint = self.hlint_3_8;
        ormolu = self.ormolu_0_7_4_0;
        retrie = doJailbreak (unmarkBroken super.retrie);
        stylish-haskell = self.stylish-haskell_0_14_6_0;
      }
    )
    apply-refact
    floskell
    fourmolu
    haskell-language-server
    hls-plugin-api
    hlint
    ormolu
    retrie
    stylish-haskell
    ;
}
