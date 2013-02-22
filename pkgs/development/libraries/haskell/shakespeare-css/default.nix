{ cabal, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.2.1";
  sha256 = "1ik0128gwziv1dajz2g73rk1yac0ymd1w59q3g8c9g8ibwxn9hca";
  buildDepends = [ parsec shakespeare text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
