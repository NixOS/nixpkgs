{ cabal, llvm, QuickCheck, random, repa, repaAlgorithms, repaIo
, vector
}:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.2.3.2";
  sha256 = "1l8bvaaap5gl62j9zinjgj8vlqq4b52p46hnj8kq9n09lxq6xq96";
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
