{ cabal, aeson, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.2.0.1";
  sha256 = "0w6dwbn3264bdjmj2hg1bppvhbd3bj8j1dkrlizjifs8g8ax0bx5";
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
