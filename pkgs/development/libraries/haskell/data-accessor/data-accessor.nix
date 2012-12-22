{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "data-accessor";
  version = "0.2.2.3";
  sha256 = "1fa1rbbs3m05y61w42vj4vqlcpqmz60v8mv3r0h6lx669k6ka5gj";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
