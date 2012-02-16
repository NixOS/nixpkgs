{ cabal, Cabal, dataAccessor, utilityHt }:

cabal.mkDerivation (self: {
  pname = "data-accessor-template";
  version = "0.2.1.9";
  sha256 = "14zp2zjxlkdi33cjif9lc1kl8m0x4brh0pk3d34wk1g1bfzynijc";
  buildDepends = [ Cabal dataAccessor utilityHt ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
