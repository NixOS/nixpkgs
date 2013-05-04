{ cabal, Cabal, filepath, HUnit, QuickCheck, random, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.7.1.0";
  sha256 = "16cb94z57ijw0q3h5p8jbvrv1vmnchsfjhrzvh3gdm3wf75fy8ln";
  testDepends = [
    Cabal filepath HUnit QuickCheck random testFramework
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
