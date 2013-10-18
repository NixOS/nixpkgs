{ cabal, aeson, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.2.0.2";
  sha256 = "1d7fmw2295ycjipaj9fjgw02y1088h2gxxk1d6sy4c165x95r6vx";
  buildDepends = [ aeson shakespeare text ];
  testDepends = [ aeson hspec HUnit shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into javascript/coffeescript at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
