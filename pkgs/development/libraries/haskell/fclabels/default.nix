{cabal, mtl} :

cabal.mkDerivation (self : {
  pname = "fclabels";
  version = "0.11.1.1";
  sha256 = "09zs9ddhhz57r2fm6ayc95xgsfjcympmgiify2p6f42w9hs34dmf";
  propagatedBuildInputs = [ mtl ];
  meta = {
    description = "First class accessor labels implemented as lenses.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
