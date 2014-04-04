{ cabal, aeson, attoparsec, httpTypes, HUnit, shakespeareText
, testFramework, testFrameworkHunit, testFrameworkThPrime, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "twitter-types";
  version = "0.2.20130101";
  sha256 = "0y7pymwcv8i5f8hqh4h018xp5bd998l8fx9f2a8x6d53c7l34wmd";
  buildDepends = [ aeson httpTypes text unorderedContainers ];
  testDepends = [
    aeson attoparsec httpTypes HUnit shakespeareText testFramework
    testFrameworkHunit testFrameworkThPrime text unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/himura/twitter-types";
    description = "Twitter JSON parser and types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
