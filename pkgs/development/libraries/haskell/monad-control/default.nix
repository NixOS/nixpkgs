{cabal, baseUnicodeSymbols, transformers}:

cabal.mkDerivation (self : {
  pname = "monad-control";
  version = "0.2.0.1";
  sha256 = "1pnckk9080g64ipvsg3n1vn4jr1083giacgy58if2ppw3dk7m97k";
  propagatedBuildInputs = [baseUnicodeSymbols transformers];
  meta = {
    description = "Lift control operations, like exception catching, through monad transformers";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

