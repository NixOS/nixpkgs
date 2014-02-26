{ cabal, baseUnicodeSymbols, HUnit, monadControl, testFramework
, testFrameworkHunit, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.2.0";
  sha256 = "1m6mk24nxkp9a78nywdb844avbqwh931gv1bxsgcbhavavzs72jj";
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
