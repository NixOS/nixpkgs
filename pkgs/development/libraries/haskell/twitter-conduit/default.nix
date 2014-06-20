{ cabal, aeson, attoparsec, authenticateOauth, caseInsensitive
, conduit, conduitExtra, dataDefault, doctest, filepath, hlint
, hspec, httpClient, httpConduit, httpTypes, lens, monadControl
, monadLogger, network, resourcet, shakespeare, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.4";
  sha256 = "0fv2m3sy1gklch4v3sarvq4xk9p7pdz1s3ssl52riy3mg076ab09";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec authenticateOauth conduit conduitExtra dataDefault
    httpClient httpConduit httpTypes lens monadLogger resourcet
    shakespeare text time transformers twitterTypes
  ];
  testDepends = [
    aeson attoparsec authenticateOauth caseInsensitive conduit
    conduitExtra dataDefault doctest filepath hlint hspec httpClient
    httpConduit httpTypes lens monadControl monadLogger network
    resourcet shakespeare text time transformers transformersBase
    twitterTypes
  ];
  meta = {
    homepage = "https://github.com/himura/twitter-conduit";
    description = "Twitter API package with conduit interface and Streaming API support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
