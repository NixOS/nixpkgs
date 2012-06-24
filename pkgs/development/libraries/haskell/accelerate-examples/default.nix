{ cabal, accelerate, accelerateCuda, accelerateIo, attoparsec, bmp
, bytestringLexing, cmdargs, criterion, cuda, deepseq, fclabels
, filepath, gloss, hashtables, mtl, mwcRandom, pgm, QuickCheck
, random, testFramework, testFrameworkQuickcheck2, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "accelerate-examples";
  version = "0.12.1.0";
  sha256 = "0vlax90yy9h4ljm87ffmnqv881nr4ssbc968mbbwi2704hn4chhb";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    accelerate accelerateCuda accelerateIo attoparsec bmp
    bytestringLexing cmdargs criterion cuda deepseq fclabels filepath
    gloss hashtables mtl mwcRandom pgm QuickCheck random testFramework
    testFrameworkQuickcheck2 vector vectorAlgorithms
  ];
  configureFlags = "-f-opencl";
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/project/accelerate/";
    description = "Examples using the Accelerate library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
