{ cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.19";
  sha256 = "1avxy55vbvkz6yj512bkb2b986y3m0b28c9c5lfc3wd2na7w1s5g";
  buildDepends = [ text transformers ];
  meta = {
    homepage = "https://john-millikin.com/software/enumerator/";
    description = "Reliable, high-performance processing with left-fold enumerators";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
