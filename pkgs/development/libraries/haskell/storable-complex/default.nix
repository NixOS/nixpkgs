{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "storable-complex";
  version = "0.2.1";
  sha256 = "0dnxnsi7m5whwwki3fry6db6gyy5qzfz8jcj1fg3fhfyf4f9wpaz";
  buildDepends = [ Cabal ];
  meta = {
    description = "Storable instance for Complex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
