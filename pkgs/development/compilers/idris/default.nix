{ cabal, ansiTerminal, binary, boehmgc, Cabal, filepath, gmp, happy
, haskeline, languageJava, libffi, llvmGeneral, mtl, parsec, split
, text, time, transformers, vector, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.9.1";
  sha256 = "1glxkx2hcr0lrvj3jjnlqqifyzyixjzq1hl86wmn540dccw82yah";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiTerminal binary Cabal filepath haskeline languageJava libffi
    llvmGeneral mtl parsec split text time transformers vector
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
