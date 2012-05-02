{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor";
  version = "0.2.2.2";
  sha256 = "1q9hx2bkp7dknr9ygx39lj93i846x8g9j7lkhkjijvsicih28yyi";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
