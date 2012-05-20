{ cabal, accelerate, accelerateCuda, accelerateIo
, attoparsec, bmp, bytestringLexing, cmdargs, criterion, cuda
, deepseq, fclabels, filepath, gloss, hashtables, mtl, mwcRandom
, pgm, QuickCheck, random, testFramework, testFrameworkQuickcheck2
, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "accelerate-examples";
  version = "0.12.0.0";
  sha256 = "08mkfr46vl8vgcsxvmbs499frvybfq0chbcj1chpb8rwy8w9fa9h";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    accelerate accelerateCuda accelerateIo attoparsec
    bmp bytestringLexing cmdargs criterion cuda deepseq fclabels
    filepath gloss hashtables mtl mwcRandom pgm QuickCheck random
    testFramework testFrameworkQuickcheck2 vector vectorAlgorithms
  ];
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Examples using the Accelerate library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
