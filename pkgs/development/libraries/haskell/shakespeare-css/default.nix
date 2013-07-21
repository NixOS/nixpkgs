{ cabal, hspec, HUnit, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.6.2";
  sha256 = "1w29k0k5124vygydavb6a5szrv5a6n9qqhf1f27bkk86br55vnw6";
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
