{ cabal, repa, repaAlgorithms, repaIo, vector, llvm }:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "2.1.0.2";
  sha256 = "056y2x8kada4d6a89sni2469c736z3d9ldp188n3i58h4kjqqfq7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ repa repaAlgorithms repaIo vector llvm ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Examples using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
