{ cabal, extensibleExceptions, mtl }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-mtl";
  version = "0.3.0.5";
  sha256 = "01c2xif4aly2lmg2qkri791ignq3r2qg4xbc8m06cdm6gh5a2dqp";
  buildDepends = [ extensibleExceptions mtl ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/MonadCatchIO-mtl";
    description = "Monad-transformer version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
