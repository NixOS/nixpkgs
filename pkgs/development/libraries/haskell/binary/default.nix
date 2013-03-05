{ cabal, Cabal, filepath, HUnit, QuickCheck, random, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.7.0.1";
  sha256 = "16srrp0qx9hsr7820b2q3sp9wp8y8sxxi8rvsh63n48w4l3canxq";
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
