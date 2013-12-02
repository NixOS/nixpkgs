{ cabal, accelerate, accelerateCuda, accelerateFft, accelerateIo
, attoparsec, bmp, bytestringLexing, cereal, criterion, ekg
, fclabels, filepath, gloss, glossAccelerate, glossRasterAccelerate
, HUnit, mwcRandom, primitive, QuickCheck, random, repa, repaIo
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "accelerate-examples";
  version = "0.14.0.0";
  sha256 = "01hxww3ypjlcfimkvf7gxl2g7msad2yw1d6m0h4kkfqvpx84nfwr";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    accelerate accelerateCuda accelerateFft accelerateIo attoparsec bmp
    bytestringLexing cereal criterion ekg fclabels filepath gloss
    glossAccelerate glossRasterAccelerate HUnit mwcRandom primitive
    QuickCheck random repa repaIo testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector vectorAlgorithms
  ];
  configureFlags = "-f-opencl";
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-examples";
    description = "Examples using the Accelerate library";
    license = self.stdenv.lib.licenses.bsd3;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
