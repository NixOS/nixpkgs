{ cabal, baseUnicodeSymbols, HUnit, monadControl, testFramework
, testFrameworkHunit, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.1.0";
  sha256 = "0c4vzyfyjvqv5q8mprgxf9ckibpp5k1zh9k5slmdsd9m1l3pwwqy";
  buildDepends = [
    baseUnicodeSymbols monadControl transformersBase
  ];
  testDepends = [
    HUnit monadControl testFramework testFrameworkHunit transformers
    transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/lifted-base";
    description = "lifted IO operations from the base library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
