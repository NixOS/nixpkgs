{ cabal, aeson, attoparsec, httpTypes, HUnit, shakespeare
, testFramework, testFrameworkHunit, testFrameworkThPrime, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "twitter-types";
  version = "0.3.20140620";
  sha256 = "02mwdgz1l1z5k5k78bjnnbabcr27xixli1gqk6rmqrarcylybvll";
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
