{ cabal, ansiWlPprint, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkThPrime, transformers, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.9.0";
  sha256 = "1nmwrg74wz8k3zwgw5aaf7padkawi0dlrclq6nsr17xz5yx524ay";
  buildDepends = [ ansiWlPprint transformers transformersCompat ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkThPrime
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
