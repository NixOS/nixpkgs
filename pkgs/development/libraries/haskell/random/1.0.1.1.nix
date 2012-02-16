{ cabal, Cabal, time }:

cabal.mkDerivation (self: {
  pname = "random";
  version = "1.0.1.1";
  sha256 = "0n8m2744gg233s357vqzq3mfhhnbhynqvp4gxsi2gb70bm03nz6z";
  buildDepends = [ Cabal time ];
  meta = {
    description = "random number library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
