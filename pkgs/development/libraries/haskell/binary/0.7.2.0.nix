{ cabal, Cabal, filepath, HUnit, QuickCheck, random, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.7.2.0";
  sha256 = "149pdhzjg9bhl66azgv0nmj3fy38s4klzk01vhzazngdiagfq6wn";
  testDepends = [
    Cabal filepath HUnit QuickCheck random testFramework
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
