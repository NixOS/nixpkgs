{ cabal, exceptionTransformers, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "exception-mtl";
  version = "0.3.0.2";
  sha256 = "1mhk1z7hz50h8ssr4s7dzdxzn02rr0njxijdddfjjw71fln3nl5h";
  buildDepends = [ exceptionTransformers mtl transformers ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Exception monad transformer instances for mtl2 classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
