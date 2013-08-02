{ cabal, binary, boehmgc, Cabal, filepath, gmp, happy, haskeline
, languageJava, libffi, llvmGeneral, mtl, parsec, split, text
, transformers, vector, vectorBinaryInstances
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.9";
  sha256 = "0wwssgpiyn7akyfrpi1khvqxx1k8753kk7151zvvymz0zkks643m";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal filepath haskeline languageJava libffi llvmGeneral mtl
    parsec split text transformers vector vectorBinaryInstances
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
