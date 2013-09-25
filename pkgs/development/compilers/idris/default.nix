{ cabal, ansiTerminal, binary, boehmgc, Cabal, filepath, gmp, happy
, haskeline, languageJava, libffi, llvmGeneral, llvmGeneralPure
, mtl, parsec, parsers, split, text, time, transformers, trifecta
, unorderedContainers, utf8String, vector, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.9.2";
  sha256 = "0xfwnlf3jca64i4piyx9scmk4z8f6rak2cvrcjwji505a9vaa0rw";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal binary Cabal filepath haskeline languageJava libffi
    llvmGeneral llvmGeneralPure mtl parsec parsers split text time
    transformers trifecta unorderedContainers utf8String vector
    vectorBinaryInstances
  ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
