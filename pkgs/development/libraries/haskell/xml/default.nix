{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml";
  version = "1.3.11";
  sha256 = "1av8cn62aaz0pl0fqqlp8wsyg36a1068qawzci8fxzasrfyyc8ca";
  buildDepends = [ text ];
  meta = {
    homepage = "http://code.galois.com";
    description = "A simple XML library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
