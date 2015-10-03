{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_34;

  # Disable GHC 7.0.x core libraries.
  array = null;
  base = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  directory = null;
  extensible-exceptions = null;
  ffi = null;
  filepath = null;
  ghc-binary = null;
  ghc-prim = null;
  haskell2010 = null;
  haskell98 = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  random = null;
  rts = null;
  template-haskell = null;
  time = null;
  unix = null;

  # binary is not a core library for this compiler.
  binary = self.binary_0_7_6_1;

  # deepseq is not a core library for this compiler.
  deepseq = self.deepseq_1_4_1_2;

  # transformers is not a core library for this compiler.
  transformers = self.transformers_0_4_3_0;

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # Newer versions don't compile.
  Cabal_1_18_1_6 = dontJailbreak super.Cabal_1_18_1_6;
  cabal-install = self.cabal-install_1_18_1_0;

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override {
    Cabal = dontJailbreak (self.Cabal_1_20_0_3.override { deepseq = dontJailbreak self.deepseq_1_3_0_1; });
  };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # https://github.com/haskell/containers/issues/134
  containers_0_4_2_1 = doJailbreak super.containers_0_4_2_1;

  # These packages need more recent versions of core libraries to compile.
  happy = addBuildTools super.happy [self.containers_0_4_2_1 self.deepseq_1_3_0_1];

  # Setup: Can't find transitive deps for haddock
  doctest = dontHaddock super.doctest;

  # Needs hashable on pre 7.10.x compilers.
  nats = addBuildDepend super.nats self.hashable;

  # Newer versions require bytestring >=0.10.
  tar = super.tar_0_4_1_0;

}
