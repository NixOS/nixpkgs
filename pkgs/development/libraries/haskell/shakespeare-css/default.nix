{ cabal, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.3";
  sha256 = "0zk4nb4v9x04vkkgbzqanfpqgw9pqinf76l7d85fzclfgwacd0bz";
  buildDepends = [ parsec shakespeare text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
