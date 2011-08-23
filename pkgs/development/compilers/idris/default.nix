{ cabal, binary, epic, happy, ivor, mtl, parsec, readline }:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.1.7.1";
  sha256 = "1449fy7ld2p6ksn43bvhpa5z7j8vx4wc2szwq85wzpwfaw10d8wb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary epic ivor mtl parsec readline ];
  buildTools = [ happy ];
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.st-andrews.ac.uk/~eb/Idris/";
    description = "Dependently Typed Functional Programming Language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
