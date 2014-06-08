{ cabal, HUnit, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "extensible-effects";
  version = "1.6.0";
  sha256 = "08g2py6iywwpsr09v6hfhq6ihjp1yq3aibz8jlqhsmagjjjxgfsq";
  buildDepends = [ transformers transformersBase ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/RobotGymnast/extensible-effects";
    description = "An Alternative to Monad Transformers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
