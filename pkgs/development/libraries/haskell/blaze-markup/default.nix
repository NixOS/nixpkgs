{ cabal, blazeBuilder, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.2.1";
  sha256 = "1drq98q70jfbxsdf3b6n5ksr1pcy8h5cgjngg6h3kd6vww3vysdy";
  buildDepends = [ blazeBuilder text ];
  testDepends = [
    blazeBuilder HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
