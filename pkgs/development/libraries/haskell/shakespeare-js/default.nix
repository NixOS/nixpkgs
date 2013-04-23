{ cabal, aeson, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.1.4";
  sha256 = "05hnqpg1icf6akvchhiam8sd2xkfiyvbwq504gnys55rxgjabfy3";
  buildDepends = [ aeson shakespeare text ];
  testDepends = [ aeson hspec HUnit shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into javascript/coffeescript at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
