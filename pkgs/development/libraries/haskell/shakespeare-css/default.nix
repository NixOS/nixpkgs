{ cabal, hspec, HUnit, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.5.1";
  sha256 = "06x57cm9ni7cgdizdwzqzpqdmgzhchax7c4mbqvk3ymgf3lybrss";
  buildDepends = [ parsec shakespeare text transformers ];
  testDepends = [ hspec HUnit shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
