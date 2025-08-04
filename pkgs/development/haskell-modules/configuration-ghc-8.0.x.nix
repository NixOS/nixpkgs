{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Should be llvmPackages_37 which has been removed from nixpkgs,
  # create attribute set to prevent eval errors.
  llvmPackages = {
    llvm = null;
    clang = null;
  };

  # Disable GHC 8.0.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # These are now core libraries in GHC 8.4.x.
  # Setup: ./mtl.cabal:59: Parse of field 'build-depends' failed.
  mtl = overrideCabal (drv: {
    version = "2.2.2";
    sha256 = "1xmy5741h8cyy0d91ahvqdz2hykkk20l8br7lg1rccnkis5g80w8";
    editedCabalFile = null;
    revision = null;
  }) super.mtl_2_3_1;
  parsec = self.parsec_3_1_13_0;
  stm = self.stm_2_5_0_0;
  text = self.text_1_2_3_1;

  # Module ‘GHC.Exts’ does not export ‘word32ToInt32#’
  alex = overrideCabal (drv: {
    version = "3.5.1.0";
    sha256 = "01rax51p8p91a5jv5i56fny4lzmwgvjlxh767gh9x5gbz23gwbn9";
  }) super.alex;

  # https://github.com/bmillwood/applicative-quoters/issues/6
  applicative-quoters = appendPatch super.applicative-quoters (
    pkgs.fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/bmillwood/applicative-quoters/pull/7.patch";
      sha256 = "026vv2k3ks73jngwifszv8l59clg88pcdr4mz0wr0gamivkfa1zy";
    }
  );

  # Requires ghc 8.2
  ghc-proofs = dontDistribute super.ghc-proofs;

  # https://github.com/thoughtbot/yesod-auth-oauth2/pull/77
  yesod-auth-oauth2 = doJailbreak super.yesod-auth-oauth2;

  # https://github.com/nominolo/ghc-syb/issues/20
  ghc-syb-utils = dontCheck super.ghc-syb-utils;

  # Newer versions require ghc>=8.2
  apply-refact = super.apply-refact_0_3_0_1;

  # This builds needs the latest Cabal version.
  cabal2nix = super.cabal2nix.overrideScope (self: super: { Cabal = self.Cabal_2_0_1_1; });

  # Add appropriate Cabal library to build this code.
  stack = addSetupDepend super.stack self.Cabal_2_0_1_1;

  # inline-c > 0.5.6.0 requires template-haskell >= 2.12
  inline-c = super.inline-c_0_5_6_1;
  inline-c-cpp = super.inline-c-cpp_0_1_0_0;

  # test dep hedgehog pulls in concurrent-output, which does not build
  # due to processing version mismatch
  either = dontCheck super.either;

  # test dep tasty has a version mismatch
  indents = dontCheck super.indents;

  # Newer versions require GHC 8.2.
  haddock-library = self.haddock-library_1_4_3;
  haddock-api = self.haddock-api_2_17_4;
  haddock = self.haddock_2_17_5;

  # happy-lib: 'library' expects no argument
  happy = overrideCabal (drv: {
    version = "1.20.1.1";
    sha256 = "06w8g3lfk2ynrfhqznhp1mnp8a5b64lj6qviixpndzf5lv2psklb";
  }) super.happy;
  happy-lib = null;

  # GHC 8.0 doesn't have semigroups included by default
  ListLike = addBuildDepend super.ListLike self.semigroups;

  # Add missing build depedency for this compiler.
  base-compat-batteries = addBuildDepend super.base-compat-batteries self.bifunctors;

}
