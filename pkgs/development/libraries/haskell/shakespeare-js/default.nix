{ cabal, aeson, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.2.0";
  sha256 = "1g37m7shqxfv7i2dk5qhvxldfzh1xipd91vcyqhks1jwa5byarzj";
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
