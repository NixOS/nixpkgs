{ cabal, dataAccessor, utilityHt }:

cabal.mkDerivation (self: {
  pname = "data-accessor-template";
  version = "0.2.1.7";
  sha256 = "08658axzznqxp4p4d6h0y0sp7rzj84ma6hrb4zvsxa3614vydgi4";
  buildDepends = [ dataAccessor utilityHt ];
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
