{ cabal, llvm, random, repa, repaAlgorithms, repaIo, vector }:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.2.2.3";
  sha256 = "0v21f8zzn05j3pjwvnb7x08q0sd375kbf450zjgsv8fzsypclr51";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ random repa repaAlgorithms repaIo vector ];
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
