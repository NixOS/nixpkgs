{ cabal, boehmgc, gmp, happy, mtl }:

cabal.mkDerivation (self: {
  pname = "epic";
  version = "0.9.2";
  sha256 = "1irvfk8xf627bfzsgbqa56816jkc99rrxpml9ycg2grq7razp9fw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  meta = {
    homepage = "http://www.dcs.st-and.ac.uk/~eb/epic.php";
    description = "Compiler for a simple functional language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
