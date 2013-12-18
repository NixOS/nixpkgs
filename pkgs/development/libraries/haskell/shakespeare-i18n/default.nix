{ cabal, hspec, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-i18n";
  version = "1.0.0.5";
  sha256 = "0f6i9pxr1lmqwcarb48swhrgab8hpkr46cv16psmbq67dr6h1dgf";
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
