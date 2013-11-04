{ cabal, accelerate, accelerateCuda, accelerateFft, accelerateIo
, attoparsec, bmp, bytestringLexing, cereal, cmdargs, criterion
, cuda, deepseq, fclabels, filepath, gloss, hashtables, mtl
, mwcRandom, pgm, QuickCheck, random, repa, repaIo, testFramework
, testFrameworkQuickcheck2, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "accelerate-examples";
  version = "0.13.0.0";
  sha256 = "18f8p47sf10zn678540qzzf5pl18w9f068s83lpz4lk0r5gf4lzx";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    accelerate accelerateCuda accelerateFft accelerateIo attoparsec bmp
    bytestringLexing cereal cmdargs criterion cuda deepseq fclabels
    filepath gloss hashtables mtl mwcRandom pgm QuickCheck random repa
    repaIo testFramework testFrameworkQuickcheck2 vector
    vectorAlgorithms
  ];
  configureFlags = "-f-opencl";
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-examples";
    description = "Examples using the Accelerate library";
    license = self.stdenv.lib.licenses.bsd3;
    hydraPlatforms = [];
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
