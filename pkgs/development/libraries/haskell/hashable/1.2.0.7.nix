{ cabal, HUnit, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.2.0.7";
  sha256 = "1v70b85g9kx0ikgxpiqpl8dp3w9hdxm75h73g69giyiy7swn9630";
  buildDepends = [ text ];
  testDepends = [
    HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
