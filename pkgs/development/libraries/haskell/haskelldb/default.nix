{ cabal, mtl, time }:

cabal.mkDerivation (self: {
  pname = "haskelldb";
  version = "2.2.2";
  sha256 = "1nwy05wsffagv62kbi8ahm6s591wal7cdl19p0fqi86qz05y9hkm";
  buildDepends = [ mtl time ];
  meta = {
    homepage = "https://github.com/m4dc4p/haskelldb";
    description = "A library of combinators for generating and executing SQL statements";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
