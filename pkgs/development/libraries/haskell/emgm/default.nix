{ cabal }:

cabal.mkDerivation (self: {
  pname = "emgm";
  version = "0.3.1";
  sha256 = "956923ec4d51f111ca6091ebccf75a1f6b99d7a173ea673cbb4787bf08f497a8";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/EMGM";
    description = "Extensible and Modular Generics for the Masses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
