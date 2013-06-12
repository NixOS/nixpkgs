{ cabal, binary, Cabal, filepath, gmp, happy, haskeline
, languageJava, libffi, mtl, parsec, split, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.8";
  sha256 = "1mxc6mic3d508ni9pqxw8q31f27shyaxs1rchfl2jg58i9w6iy7h";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal filepath haskeline languageJava libffi mtl parsec
    split text transformers
  ];
  buildTools = [ happy ];
  extraLibraries = [ gmp ];
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
