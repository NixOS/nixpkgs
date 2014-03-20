{ cabal, random, testFramework, tfRandom }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.7";
  sha256 = "0l7qijcwbf81wdizsv7qzmm73dsjbldm2sx305cqs6bmnynbl508";
  buildDepends = [ random tfRandom ];
  testDepends = [ testFramework ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
