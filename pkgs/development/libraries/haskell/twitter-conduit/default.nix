{ cabal, aeson, attoparsec, attoparsecConduit, authenticateOauth
, conduit, dataDefault, doctest, failure, filepath, hlint
, httpClientMultipart, httpConduit, httpTypes, lens, liftedBase
, monadControl, monadLogger, resourcet, shakespeareText, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.2";
  sha256 = "1bkn0lfwwr5lnw4xfzdjiad48r1qz6m4z0nq1inz45gflmjwmghj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec attoparsecConduit authenticateOauth conduit
    dataDefault failure httpClientMultipart httpConduit httpTypes lens
    liftedBase monadControl monadLogger resourcet shakespeareText text
    time transformers transformersBase twitterTypes
  ];
  testDepends = [ doctest filepath hlint ];
  meta = {
    homepage = "https://github.com/himura/twitter-conduit";
    description = "Twitter API package with conduit interface and Streaming API support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
