{ cabal, aeson, attoparsec, httpTypes, HUnit, shakespeare
, testFramework, testFrameworkHunit, testFrameworkThPrime, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "twitter-types";
  version = "0.2.20140424";
  sha256 = "0ap2l3mclcilm58awz0fdayzcs7fckv69l6xdklp1yqyj6i7zk9a";
  buildDepends = [ aeson httpTypes text unorderedContainers ];
  testDepends = [
    aeson attoparsec httpTypes HUnit shakespeare testFramework
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
