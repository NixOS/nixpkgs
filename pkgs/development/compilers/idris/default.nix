{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, split, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.6.1";
  sha256 = "1wy79rrm5pvg77i9nvwkcg6swsdbmg2izch48n4lj4idj0ga5g62";
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
