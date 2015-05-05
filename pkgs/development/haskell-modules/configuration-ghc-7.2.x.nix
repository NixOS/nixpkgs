{ pkgs }:

with import ./lib.nix { inherit pkgs; };

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

  # deepseq is not a core library for this compiler.
  deepseq = self.deepseq_1_4_1_1;

  # transformers is not a core library for this compiler.
  transformers = self.transformers_0_4_3_0;

  # https://github.com/haskell/cabal/issues/2322
  Cabal_1_22_3_0 = super.Cabal_1_22_3_0.override { binary = self.binary_0_7_4_0; process = self.process_1_2_3_0; };

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # Needs Cabal >= 1.18.x.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = dontJailbreak self.Cabal_1_18_1_6; };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # The old containers version won't compile against newer versions of deepseq.
  containers_0_4_2_1 = super.containers_0_4_2_1.override { deepseq = self.deepseq_1_3_0_1; };

  # These packages need more recent versions of core libraries to compile.
  happy = addBuildTools super.happy [self.containers_0_4_2_1 self.deepseq_1_3_0_1];

  # Setup: Can't find transitive deps for haddock
  doctest = dontHaddock super.doctest;

  # Needs hashable on pre 7.10.x compilers.
  nats = addBuildDepend super.nats self.hashable;

}
