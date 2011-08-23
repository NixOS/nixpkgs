{ cabal, boehmgc, gmp, happy, mtl }:

cabal.mkDerivation (self: {
  pname = "epic";
  version = "0.1.11";
  sha256 = "12dz1wjaf3n8fqk46vhpnxq9z633wi6wyihcmif7amxmqv3l8zn9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  buildTools = [ happy ];
  extraLibraries = [ gmp boehmgc ];
  noHaddock = true;
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
