{ cabal, dataDefault, semigroups }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.2.3.1";
  sha256 = "0ldc9w35yzlrz78kakkqial32g2c7da9b5v334jh5wpgsn7lrm3n";
  buildDepends = [ dataDefault semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Provides newtype wrappers for phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
