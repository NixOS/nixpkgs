{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "monads-fd";
  version = "0.0.0.1";
  sha256 = "7eaac97b2c91a670171f18ebeb3f73b1a45e16576851279f73ea2e1f5ec63b25";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Monad classes, using functional dependencies";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

