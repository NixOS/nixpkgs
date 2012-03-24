{ cabal, llvm, random, repa, repaAlgorithms, repaIo, vector }:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "2.2.0.1";
  sha256 = "0rqpq4v2ir86x9z0aw8pcz929imcw9lf415j88kg12x2rk451mm0";
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
