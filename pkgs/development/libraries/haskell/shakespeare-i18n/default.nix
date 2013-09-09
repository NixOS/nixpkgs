{ cabal, hspec, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-i18n";
  version = "1.0.0.4";
  sha256 = "1ia73rq9kva2v4vxcyc2nzbvvkrbwrx48gjhnljx39szx1klyk3l";
  buildDepends = [ parsec shakespeare text ];
  testDepends = [ hspec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A type-based approach to internationalization";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
