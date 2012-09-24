{ cabal, llvm, random, repa, repaAlgorithms, repaIo, vector }:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.2.2.1";
  sha256 = "17v7ay33fwxjm0ip09jhh979rc6hzfxrrj1hkwj7x4x9gkd79yn7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ random repa repaAlgorithms repaIo vector ];
  extraLibraries = [ llvm ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Examples using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
