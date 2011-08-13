{ cabal, dataAccessor, utilityHt }:

cabal.mkDerivation (self: {
  pname = "data-accessor-template";
  version = "0.2.1.8";
  sha256 = "0bx0w4vkigq20pa31sdygj4idi3iywkpclbllrw38ma1j19033zk";
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
