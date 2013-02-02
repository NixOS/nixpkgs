{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, split, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.6";
  sha256 = "1yml1k4bis210hgi898hgs4wj5p34ainlj7vwy5lh7bjkvrksgq1";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal filepath haskeline mtl parsec split transformers
  ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
