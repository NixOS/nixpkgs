{ cabal, baseUnicodeSymbols, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.2.1";
  sha256 = "17wfdg3a2kkx1jwh7gfgbyx4351b420krsf8syb8l9xrl9gdz5a3";
  buildDepends = [
    baseUnicodeSymbols transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
