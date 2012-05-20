{ cabal, accelerate, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.12.0.0";
  sha256 = "0jc6vcxmji11kj041cds6j90by3mvaybswgmsiflxdlf4zlagd6h";
  buildDepends = [ accelerate repa vector ];
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
