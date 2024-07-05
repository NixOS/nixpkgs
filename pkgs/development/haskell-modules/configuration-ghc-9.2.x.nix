{ pkgs, haskellLib }:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs) lib;
in

self: super: {

  llvmPackages = pkgs.lib.dontRecurseIntoAttrs self.ghc.llvmPackages;

  # Disable GHC 9.2.x core libraries.
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
  # GHC only builds terminfo if it is a native compiler
  terminfo = if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then null else doDistribute self.terminfo_0_4_1_6;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  # GHC only bundles the xhtml library if haddock is enabled, check if this is
  # still the case when updating: https://gitlab.haskell.org/ghc/ghc/-/blob/0198841877f6f04269d6050892b98b5c3807ce4c/ghc.mk#L463
  xhtml = if self.ghc.hasHaddock or true then null else doDistribute self.xhtml_3000_3_0_0;

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # weeder >= 2.5 requires GHC 9.4
  weeder = doDistribute self.weeder_2_4_1;
  # Allow dhall 1.42.*
  weeder_2_4_1 = doJailbreak (super.weeder_2_4_1.override {
    # weeder < 2.6 only supports algebraic-graphs < 0.7
    # We no longer have matching test deps for algebraic-graphs 0.6.1 in the set
    algebraic-graphs = dontCheck self.algebraic-graphs_0_6_1;
  });


  haskell-language-server = lib.pipe super.haskell-language-server [
    (disableCabalFlag "fourmolu")
    (disableCabalFlag "ormolu")
    (disableCabalFlag "stylishHaskell")
    (overrideCabal (drv: {
      # Disabling the build flags isn't enough: `Setup configure` still configures
      # every component for building and complains about missing dependencies.
      # Thus we have to mark the undesired components as non-buildable.
      postPatch = drv.postPatch or "" + ''
        for lib in hls-ormolu-plugin hls-fourmolu-plugin; do
          sed -i "/^library $lib/a\  buildable: False" haskell-language-server.cabal
        done
      '';
    }))
    (d: d.override {
      ormolu = null;
      fourmolu = null;
    })
  ];

  # For GHC < 9.4, some packages need data-array-byte as an extra dependency
  hashable = addBuildDepends [ self.data-array-byte ] super.hashable;
  primitive = addBuildDepends [ self.data-array-byte ] super.primitive;
  primitive-unlifted = super.primitive-unlifted_0_1_3_1;
  # Too strict lower bound on base
  primitive-addr = doJailbreak super.primitive-addr;

  # Jailbreaks & Version Updates
  hashable-time = doJailbreak super.hashable-time;

  # Depends on utf8-light which isn't maintained / doesn't support base >= 4.16
  # https://github.com/haskell-infra/hackage-trustees/issues/347
  # https://mail.haskell.org/pipermail/haskell-cafe/2022-October/135613.html
  language-javascript_0_7_0_0 = dontCheck super.language-javascript_0_7_0_0;

  # Tests depend on `parseTime` which is no longer available
  hourglass = dontCheck super.hourglass;

  # Needs to match ghc version
  ghc-tags = doDistribute self.ghc-tags_1_5;

  # For "ghc-lib" flag see https://github.com/haskell/haskell-language-server/issues/3185#issuecomment-1250264515
  hlint = enableCabalFlag "ghc-lib" super.hlint;

  # 0.2.2.3 requires Cabal >= 3.8
  shake-cabal = doDistribute self.shake-cabal_0_2_2_2;

  # https://github.com/sjakobi/bsb-http-chunked/issues/38
  bsb-http-chunked = dontCheck super.bsb-http-chunked;

  # https://github.com/NixOS/cabal2nix/issues/554
  # https://github.com/clash-lang/clash-compiler/blob/f0f6275e19b8c672f042026c478484c5fd45191d/README.md#ghc-compatibility
  clash-prelude = dontDistribute (markBroken super.clash-prelude);

  # Too strict upper bound on bytestring, relevant for GHC 9.2.6 specifically
  # https://github.com/protolude/protolude/issues/127#issuecomment-1428807874
  protolude = doJailbreak super.protolude;

  # https://github.com/fpco/inline-c/pull/131
  inline-c-cpp =
    (if isDarwin then appendConfigureFlags ["--ghc-option=-fcompact-unwind"] else x: x)
    super.inline-c-cpp;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = super.ghc-exactprint_1_5_0;

  # Requires GHC < 9.4
  ghc-source-gen = doDistribute (unmarkBroken super.ghc-source-gen);

  # Packages which need compat library for GHC < 9.6
  inherit
    (lib.mapAttrs
      (_: addBuildDepends [ self.foldable1-classes-compat ])
      super)
    indexed-traversable
    OneTuple
    these
  ;
  base-compat-batteries = addBuildDepends [
    self.foldable1-classes-compat
    self.OneTuple
  ] super.base-compat-batteries;
}
