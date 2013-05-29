{ cabal, boehmgc, Cabal, gmp, happy, mtl }:

cabal.mkDerivation (self: {
  pname = "epic";
  version = "0.9.3";
  sha256 = "1x8y3ljha8r52pw83mjfv5i49dq0b7i1xbxg8j9hlvr2vwfa4237";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal mtl ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  meta = {
    homepage = "http://www.dcs.st-and.ac.uk/~eb/epic.php";
    description = "Compiler for a simple functional language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
