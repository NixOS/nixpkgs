{ cabal, baseUnicodeSymbols, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.2.0.3";
  sha256 = "0z7wjilrx6phqs2gxwv65dy1n3mc0j8hj3adshkwy6z8ggj283nh";
  buildDepends = [ baseUnicodeSymbols transformers ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control/";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
