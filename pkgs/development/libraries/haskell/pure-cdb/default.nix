{ cabal, binary, mtl, vector }:

cabal.mkDerivation (self: {
  pname = "pure-cdb";
  version = "0.1";
  sha256 = "0fxfhd73h5frnjpk617lspwf17wldsrd5a5cxar5y3a8wi0i4b8c";
  buildDepends = [ binary mtl vector ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bosu/pure-cdb";
    description = "Another pure-haskell CDB (Constant Database) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
