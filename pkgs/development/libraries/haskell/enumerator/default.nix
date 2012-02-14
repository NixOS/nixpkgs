{ cabal, Cabal, text, transformers }:

cabal.mkDerivation (self: {
  pname = "enumerator";
  version = "0.4.18";
  sha256 = "0xqgcn3xs0i7kdy73lizfhs4dzj8crf2x9pmb9d37kqrhdgznl9d";
  buildDepends = [ Cabal text transformers ];
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
