{ cabal, ansiTerminal, ansiWlPprint, binary, boehmgc, Cabal
, filepath, gmp, happy, haskeline, languageJava, libffi
, llvmGeneral, llvmGeneralPure, mtl, parsec, parsers, split, text
, time, transformers, trifecta, unorderedContainers, utf8String
, vector, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.9.3";
  sha256 = "1l19xx0xbcwlnnh2w0rmri7wwixffzfrafpbji64nwyx1awz4iab";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal ansiWlPprint binary Cabal filepath haskeline
    languageJava libffi llvmGeneral llvmGeneralPure mtl parsec parsers
    split text time transformers trifecta unorderedContainers
    utf8String vector vectorBinaryInstances
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
