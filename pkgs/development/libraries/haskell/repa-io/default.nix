{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.1.0.1";
  sha256 = "1il0zsba9qz0560c56f9hn6wks5kk1bvh8bpng46w70c12gxh81w";
  buildDepends = [ binary bmp repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
