{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_34;

  # Disable GHC 7.6.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
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
  Cabal_1_22_4_0 = super.Cabal_1_22_4_0.override { binary = dontCheck self.binary_0_8_4_1; };

  # Avoid inconsistent 'binary' versions from 'text' and 'Cabal'.
  cabal-install = super.cabal-install.overrideScope (self: super: { binary = dontCheck self.binary_0_8_4_1; });

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_20_0_4; };

  # Haddock chokes on the prologue from the cabal file.
  ChasingBottoms = dontHaddock super.ChasingBottoms;

  # Later versions require a newer version of bytestring than we have.
  aeson = self.aeson_0_7_0_6;

  # The test suite depends on time >=1.4.0.2.
  cookie = dontCheck super.cookie;

  # Work around bytestring >=0.10.2.0 requirement.
  streaming-commons = addBuildDepend super.streaming-commons self.bytestring-builder;

  # Choose appropriate flags for our version of 'bytestring'.
  bytestring-builder = disableCabalFlag super.bytestring-builder "bytestring_has_builder";

  # Tagged is not part of base in this environment.
  contravariant = addBuildDepend super.contravariant self.tagged;
  reflection = dontHaddock (addBuildDepend super.reflection self.tagged);

  # The compat library is empty in the presence of mtl 2.2.x.
  mtl-compat = dontHaddock super.mtl-compat;

  # Newer versions require a more recent compiler.
  control-monad-free = super.control-monad-free_0_5_3;

  # Needs hashable on pre 7.10.x compilers.
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # https://github.com/magthe/sandi/issues/7
  sandi = overrideCabal super.sandi (drv: {
    postPatch = "sed -i -e 's|base ==4.8.*,|base,|' sandi.cabal";
  });

  # blaze-builder requires an additional build input on older compilers.
  blaze-builder = addBuildDepend super.blaze-builder super.bytestring-builder;

  # available convertible package won't build with the available
  # bytestring and ghc-mod won't build without convertible
  convertible = markBroken super.convertible;
  ghc-mod = markBroken super.ghc-mod;

  # Needs void on pre 7.10.x compilers.
  conduit = addBuildDepend super.conduit self.void;

  # Needs additional inputs on pre 7.10.x compilers.
  semigroups = addBuildDepends super.semigroups (with self; [bytestring-builder nats tagged unordered-containers transformers]);
  lens = addBuildDepends super.lens (with self; [doctest generic-deriving nats simple-reflect]);
  distributive = addBuildDepend super.distributive self.semigroups;
  QuickCheck = addBuildDepend super.QuickCheck self.semigroups;

  # Haddock doesn't cope with the new markup.
  bifunctors = dontHaddock super.bifunctors;

  # Breaks a dependency cycle between QuickCheck and semigroups
  unordered-containers = dontCheck super.unordered-containers;

}
