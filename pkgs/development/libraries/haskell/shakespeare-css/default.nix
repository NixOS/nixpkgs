{ cabal, hspec, HUnit, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.6.5";
  sha256 = "1jmi5rh4a9x7md90sgzk6pmn0pn4h9mn44z8z0haq3fzflravqdk";
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
