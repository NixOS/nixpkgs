{cabal}:

cabal.mkDerivation (self : {
  pname = "monad-loops";
  version = "0.3.1.1";
  sha256 = "086aqd1x1xc6irp24z1lwhzrknw9r2wbs8fnxz6vyi75m3rqvdcv";
  meta = {
    description = "Monadic loops";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

