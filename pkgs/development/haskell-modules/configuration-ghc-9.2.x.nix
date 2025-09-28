{
  config,
  pkgs,
  haskellLib,
}:

with haskellLib;

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (pkgs) lib;
in

self: super: {

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

  # Need the Cabal-syntax-3.6.0.0 fake package for Cabal < 3.8 to allow callPackage and the constraint solver to work
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  # These core package only exist for GHC >= 9.4. The best we can do is feign
  # their existence to callPackages, but their is no shim for lower GHC versions.
  system-cxx-std-lib = null;

  # Becomes a core package in GHC >= 9.8
  semaphore-compat = doDistribute self.semaphore-compat_1_0_0;

  # weeder >= 2.5 requires GHC 9.4
  weeder = doDistribute self.weeder_2_4_1;
  # Allow dhall 1.42.*
  weeder_2_4_1 = doJailbreak (
    super.weeder_2_4_1.override {
      # weeder < 2.6 only supports algebraic-graphs < 0.7
      # We no longer have matching test deps for algebraic-graphs 0.6.1 in the set
      algebraic-graphs = dontCheck self.algebraic-graphs_0_6_1;
    }
  );

  haskell-language-server =
    lib.throwIf config.allowAliases
      "haskell-language-server has dropped support for ghc 9.2 in version 2.10.0.0, please use a newer ghc version or an older nixpkgs version"
      (markBroken super.haskell-language-server);

  # For GHC < 9.4, some packages need data-array-byte as an extra dependency
  hashable = addBuildDepends [ self.data-array-byte ] super.hashable;
  primitive = addBuildDepends [ self.data-array-byte ] super.primitive;
  primitive-unlifted = super.primitive-unlifted_0_1_3_1;
  # Too strict lower bound on base
  primitive-addr = doJailbreak super.primitive-addr;

  # Needs base-orphans for GHC < 9.8 / base < 4.19
  some = addBuildDepend self.base-orphans super.some;

  # Jailbreaks & Version Updates
  hashable-time = doJailbreak super.hashable-time;

  # Depends on utf8-light which isn't maintained / doesn't support base >= 4.16
  # https://github.com/haskell-infra/hackage-trustees/issues/347
  # https://mail.haskell.org/pipermail/haskell-cafe/2022-October/135613.html
  language-javascript_0_7_0_0 = dontCheck super.language-javascript_0_7_0_0;

  # Needs to match ghc-lib version
  ghc-tags = doDistribute (doJailbreak self.ghc-tags_1_7);

  # Needs to match ghc-lib
  hlint = doDistribute self.hlint_3_6_1;

  # ghc-lib >= 9.8 and friends no longer build with GHC 9.2 since they require semaphore-compat
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

  # 0.2.2.3 requires Cabal >= 3.8
  shake-cabal = doDistribute self.shake-cabal_0_2_2_2;

  # Tests require nothunks < 0.3 (conflicting with Stackage) for GHC < 9.8
  aeson = dontCheck super.aeson;

  # https://github.com/NixOS/cabal2nix/issues/554
  # https://github.com/clash-lang/clash-compiler/blob/f0f6275e19b8c672f042026c478484c5fd45191d/README.md#ghc-compatibility
  clash-prelude = dontDistribute (markBroken super.clash-prelude);

  # Too strict upper bound on bytestring, relevant for GHC 9.2.6 specifically
  # https://github.com/protolude/protolude/issues/127#issuecomment-1428807874
  protolude = doJailbreak super.protolude;

  # https://github.com/fpco/inline-c/pull/131
  inline-c-cpp =
    (if isDarwin then appendConfigureFlags [ "--ghc-option=-fcompact-unwind" ] else x: x)
      super.inline-c-cpp;

  # A given major version of ghc-exactprint only supports one version of GHC.
  ghc-exactprint = super.ghc-exactprint_1_5_0;

  # only broken for >= 9.6
  calligraphy = doDistribute (unmarkBroken super.calligraphy);

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
}
