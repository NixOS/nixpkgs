{ cabal, baseUnicodeSymbols, HUnit, monadControl, testFramework
, testFrameworkHunit, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.1.1";
  sha256 = "062mdh364c4adnyc3l037zi1aaqvgm43g1x6vf3pjb75c3sayc5k";
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
