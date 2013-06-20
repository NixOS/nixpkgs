{ cabal, hspec, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-i18n";
  version = "1.0.0.3";
  sha256 = "0k5daz6ayc4d6zxsq7p27bp5fq4qr31qxw9z9mwb5xcz2404d00r";
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
