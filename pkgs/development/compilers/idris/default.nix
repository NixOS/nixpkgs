{ cabal, ansiTerminal, ansiWlPprint, binary, boehmgc, Cabal
, deepseq, filepath, gmp, happy, haskeline, languageJava, mtl
, network, parsers, split, text, time, transformers, trifecta
, unorderedContainers, utf8String, vector, vectorBinaryInstances
, xml
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.10";
  sha256 = "0sbadjc4kj59f5240036pryxr4b6k6y2zkmszv99wq660mm7a3d3";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal ansiWlPprint binary Cabal deepseq filepath haskeline
    languageJava mtl network parsers split text time transformers
    trifecta unorderedContainers utf8String vector
    vectorBinaryInstances xml
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
