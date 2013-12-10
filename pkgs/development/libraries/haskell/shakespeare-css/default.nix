{ cabal, hspec, HUnit, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.6.6";
  sha256 = "1xjavlw88nj5ila2b4m44zj0qgkpq147b30x1arwv0ik8szgml9k";
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
