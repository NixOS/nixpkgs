{ cabal, hspec, HUnit, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.7";
  sha256 = "108vlxbis8g7pkldsd6r2b8il7fdqb98n64idc4l2lvkwz3lnr36";
  buildDepends = [ parsec shakespeare text transformers ];
  testDepends = [ hspec HUnit shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
