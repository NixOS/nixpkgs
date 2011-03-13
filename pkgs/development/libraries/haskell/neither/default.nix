{cabal, failure, monadPeel, transformers}:

cabal.mkDerivation (self : {
  pname = "neither";
  version = "0.2.0";
  sha256 = "0a2lyx3dvgzj4g6p69x1fma4rmwxrykji3hc4diqgc4hx02p16jh";
  propagatedBuildInputs = [
    failure monadPeel transformers
  ];
  meta = {
    description = "A simple type class for success/failure computations";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
