{ cabal, dataAccessor, utilityHt }:

cabal.mkDerivation (self: {
  pname = "data-accessor-template";
  version = "0.2.1.10";
  sha256 = "11a4c0g74ppl7nls0dhx6xs47dfcq1wp7bd8qgdba6hhn645afzy";
  buildDepends = [ dataAccessor utilityHt ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
