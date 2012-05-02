{ cabal, baseUnicodeSymbols, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.1.3";
  sha256 = "0sx0jr8hccqh519sgn428y4xfk6m5jpwfm9201vn8zj1cxlppjv9";
  buildDepends = [
    baseUnicodeSymbols transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
