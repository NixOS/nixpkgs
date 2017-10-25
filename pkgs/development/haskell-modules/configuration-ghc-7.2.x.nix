{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_34;

  # Disable GHC 7.2.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  directory = null;
  extensible-exceptions = null;
  ffi = null;
  filepath = null;
  ghc-prim = null;
  haskell2010 = null;
  haskell98 = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  time = null;
  unix = null;

  # These packages are core libraries in GHC 7.10.x, but not here.
  deepseq = self.deepseq_1_3_0_1;
  haskeline = self.haskeline_0_7_3_1;
  terminfo = self.terminfo_0_4_0_2;
  transformers = self.transformers_0_4_3_0;
  xhtml = self.xhtml_3000_2_1;

  # https://github.com/haskell/cabal/issues/2322
  Cabal_1_22_4_0 = super.Cabal_1_22_4_0.override { binary = self.binary_0_8_5_1; process = self.process_1_2_3_0; };

  # Requires ghc 8.2
  ghc-proofs = dontDistribute super.ghc-proofs;

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override {
    Cabal = self.Cabal_1_20_0_4.override { deepseq = self.deepseq_1_3_0_1; };
  };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # The old containers version won't compile against newer versions of deepseq.
  containers_0_4_2_1 = super.containers_0_4_2_1.override { deepseq = self.deepseq_1_3_0_1; };

  # These packages need more recent versions of core libraries to compile.
  happy = addBuildTools super.happy [self.containers_0_4_2_1 self.deepseq_1_3_0_1];

  # Setup: Can't find transitive deps for haddock
  doctest = dontHaddock super.doctest;
  hsdns = dontHaddock super.hsdns;

  # Needs hashable on pre 7.10.x compilers.
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # Newer versions require bytestring >=0.10.
  tar = super.tar_0_4_1_0;

  # These builds need additional dependencies on old compilers.
  conduit = addBuildDepend super.conduit self.void;
  reflection = addBuildDepend super.reflection self.tagged;
  semigroups = addBuildDepend super.semigroups self.nats;
  optparse-applicative = addBuildDepend super.optparse-applicative self.semigroups;
  text = addBuildDepend super.text self.bytestring-builder;

  # Newer versions don't compile any longer.
  network_2_6_3_1 = dontCheck super.network_2_6_3_1;
  network = self.network_2_6_3_1;

}
