{ cabal, aeson, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.1.4.1";
  sha256 = "1mvsdbc3c6vgdpdb4m8b2d28vrh79v64vb9wkpnvhfg0jn7kb5c0";
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
