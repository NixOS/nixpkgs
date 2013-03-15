{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, split, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.7";
  sha256 = "0y3rnxbs2s7kxlzlc347vwpylw2p0pdz50zgkyii21gd6klqvd45";
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
