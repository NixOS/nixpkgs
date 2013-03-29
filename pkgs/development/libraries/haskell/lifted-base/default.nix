{ cabal, baseUnicodeSymbols, HUnit, monadControl, testFramework
, testFrameworkHunit, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.0.3";
  sha256 = "1sfrak4jf3mvns9y6iadyhj8zvy4wyrqiaxihrxv2qby14c45psx";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
