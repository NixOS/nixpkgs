{ cabal, llvm, QuickCheck, random, repa, repaAlgorithms, repaIo
, vector
}:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.2.5.1";
  sha256 = "0xrjfmwbq8mhcim261da7i68mp5jxkqiwjy2mhd1lgkr63m6x18j";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    QuickCheck random repa repaAlgorithms repaIo vector
  ];
  extraLibraries = [ llvm ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Examples using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
