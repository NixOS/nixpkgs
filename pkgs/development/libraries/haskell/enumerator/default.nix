{ cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.13.1";
  sha256 = "5fcafe316444adfb66c213ffb71359560f48eafe03bb2df99bfba17d2e3153c8";
  buildDepends = [ text transformers ];
  meta = {
    homepage = "http://john-millikin.com/software/enumerator/";
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
