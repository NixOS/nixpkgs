{ cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.3.1";
  sha256 = "0lc1ma6h5wdfl4crnvg1vyvlx4xvps4l2nwb9dl6nyspmpjad807";
  buildDepends = [ mtl typeEquality ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
