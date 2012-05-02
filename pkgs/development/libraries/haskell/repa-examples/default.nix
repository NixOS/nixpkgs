{ cabal, llvm, random, repa, repaAlgorithms, repaIo, vector }:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.1.3.1";
  sha256 = "15fg356a8sa48vmgn5fxgbj3s48hixsl1x4a8ds0mvvv8m0zlra8";
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
