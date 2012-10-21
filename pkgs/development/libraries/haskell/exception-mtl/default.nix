{ cabal, exceptionTransformers, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "exception-mtl";
  version = "0.3.0.3";
  sha256 = "1mmkp16c5ixknhm69a2zjrs9q0dd5ragmljnjjd6lxpakdlw64ww";
  buildDepends = [ exceptionTransformers mtl transformers ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Exception monad transformer instances for mtl2 classes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
