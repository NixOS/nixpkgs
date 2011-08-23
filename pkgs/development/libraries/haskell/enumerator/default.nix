{ cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.14";
  sha256 = "06bvrr76y12r3i1xi1s98fc1v6mcmn8nzhbp80wgyi743ksqcr1d";
  buildDepends = [ text transformers ];
  meta = {
    homepage = "https://john-millikin.com/software/enumerator/";
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
