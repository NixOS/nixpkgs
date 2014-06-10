{ cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.3.3";
  sha256 = "1772r6rfajcn622dxwy9z1bvv53l5xj6acbcv8n9p7h01fs52mpr";
  buildDepends = [ mtl typeEquality ];
  noHaddock = true;
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
