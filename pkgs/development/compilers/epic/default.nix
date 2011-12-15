{ cabal, boehmgc, gmp, happy, mtl }:

cabal.mkDerivation (self: {
  pname = "epic";
  version = "0.9";
  sha256 = "0bxvabzizq0msj0fy02vqj0pylq4cbymsypi6w2babwykscrdgm0";
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
