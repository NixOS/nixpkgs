{cabal, dataDefault, semigroups} :

cabal.mkDerivation (self : {
  pname = "tagged";
  version = "0.2.2.3";
  sha256 = "16xnalvq7mch0zsxn2kix4xysn0lvcp9jdkxb1i5n03f94c92k52";
  propagatedBuildInputs = [ dataDefault semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Provides newtype wrappers for phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
