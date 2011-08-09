{cabal, mtl} :

cabal.mkDerivation (self : {
  pname = "MonadCatchIO-mtl";
  version = "0.3.0.3";
  sha256 = "0sqvdrvl1z6y176jwxv02aam4fz2awmqyjba803w816pp9m9a5pr";
  propagatedBuildInputs = [ mtl ];
  meta = {
    homepage = "http://code.haskell.org/~jcpetruzza/MonadCatchIO-mtl";
    description = "Monad-transformer version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
