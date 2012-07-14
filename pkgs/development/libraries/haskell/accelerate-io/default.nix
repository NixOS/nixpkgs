{ cabal, accelerate, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.12.1.0";
  sha256 = "1hcyshzfh7ldswv7sjklxlw5h1hx7spx6dy23bvdryrkq929gb8a";
  buildDepends = [ accelerate repa vector ];
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
