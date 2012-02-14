{ cabal, Cabal, stm }:

cabal.mkDerivation (self: {
  pname = "monad-loops";
  version = "0.3.1.1";
  sha256 = "086aqd1x1xc6irp24z1lwhzrknw9r2wbs8fnxz6vyi75m3rqvdcv";
  buildDepends = [ Cabal stm ];
  meta = {
    homepage = "http://code.haskell.org/~mokus/monad-loops";
    description = "Monadic loops";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
