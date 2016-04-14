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

  # These packages are core libraries in GHC 7.10.x, but not here.
  binary = self.binary_0_7_6_1;
  deepseq = self.deepseq_1_3_0_1;
  haskeline = self.haskeline_0_7_2_1;
  hoopl = self.hoopl_3_10_2_0;
  terminfo = self.terminfo_0_4_0_1;
  transformers = self.transformers_0_4_3_0;
  xhtml = self.xhtml_3000_2_1;

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # Newer versions don't compile.
  Cabal_1_18_1_7 = dontJailbreak super.Cabal_1_18_1_7;
  cabal-install = self.cabal-install_1_18_1_0;

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override {
    Cabal = dontJailbreak (self.Cabal_1_20_0_4.override { deepseq = dontJailbreak self.deepseq_1_3_0_1; });
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
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # Newer versions require bytestring >=0.10.
  tar = super.tar_0_4_1_0;

  # Needs void on pre 7.10.x compilers.
  conduit = addBuildDepend super.conduit self.void;

  # Needs tagged on pre 7.6.x compilers.
  reflection = addBuildDepend super.reflection self.tagged;

}
