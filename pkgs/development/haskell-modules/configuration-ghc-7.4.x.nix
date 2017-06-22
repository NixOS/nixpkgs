{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_34;

  # Disable GHC 7.4.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  extensible-exceptions = null;
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
  haskeline = self.haskeline_0_7_3_1;
  terminfo = self.terminfo_0_4_0_2;
  transformers = self.transformers_0_4_3_0;
  xhtml = self.xhtml_3000_2_1;

  # https://github.com/haskell/cabal/issues/2322
  Cabal_1_22_4_0 = super.Cabal_1_22_4_0.override { binary = dontCheck self.binary_0_8_5_1; };

  # Avoid inconsistent 'binary' versions from 'text' and 'Cabal'.
  cabal-install = super.cabal-install.overrideScope (self: super: { binary = dontCheck self.binary_0_8_5_1; });

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_20_0_4; };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # https://github.com/haskell/primitive/issues/16
  primitive = dontCheck super.primitive;

  # https://github.com/tibbe/unordered-containers/issues/96
  unordered-containers = dontCheck super.unordered-containers;

  # The test suite depends on time >=1.4.0.2.
  cookie = dontCheck super.cookie ;

  # Work around bytestring >=0.10.2.0 requirement.
  streaming-commons = addBuildDepend super.streaming-commons self.bytestring-builder;

  # Choose appropriate flags for our version of 'bytestring'.
  bytestring-builder = disableCabalFlag super.bytestring-builder "bytestring_has_builder";

  # Newer versions require a more recent compiler.
  control-monad-free = super.control-monad-free_0_5_3;

  # Needs hashable on pre 7.10.x compilers.
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # Test suite won't compile.
  unix-time = dontCheck super.unix-time;

  # The test suite depends on mockery, which pulls in logging-facade, which
  # doesn't compile with this older version of base:
  # https://github.com/sol/logging-facade/issues/14
  doctest = dontCheck super.doctest;

  # Avoid depending on tasty-golden.
  monad-par = dontCheck super.monad-par;

  # Newer versions require bytestring >=0.10.
  tar = super.tar_0_4_1_0;

  # Needs void on pre 7.10.x compilers.
  conduit = addBuildDepend super.conduit self.void;

  # Needs tagged on pre 7.6.x compilers.
  reflection = addBuildDepend super.reflection self.tagged;

  # These builds need additional dependencies on old compilers.
  semigroups = addBuildDepends super.semigroups (with self; [nats bytestring-builder tagged unordered-containers transformers]);
  QuickCheck = addBuildDepends super.QuickCheck (with self; [nats semigroups]);
  optparse-applicative = addBuildDepend super.optparse-applicative self.semigroups;

  # Newer versions don't compile any longer.
  network_2_6_3_1 = dontCheck super.network_2_6_3_1;
  network = self.network_2_6_3_1;

}
