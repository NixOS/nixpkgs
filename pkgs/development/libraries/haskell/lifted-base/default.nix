{ cabal, baseUnicodeSymbols, HUnit, monadControl, testFramework
, testFrameworkHunit, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.0.2";
  sha256 = "19xzparj0k5h4wx71gvbd7l653fak1p57za236sncmar8cps5pdx";
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
