{ cabal, hspec, parsec, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.2.0.1";
  sha256 = "07qfbqvq8fqbf7y43h0qq2gk9brpf4g0k7gghrjzyjrd57v5zygp";
  buildDepends = [ parsec systemFileio systemFilepath text time ];
  testDepends = [
    hspec parsec systemFileio systemFilepath text time
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
