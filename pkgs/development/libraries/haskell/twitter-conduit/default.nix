{ cabal, aeson, attoparsec, attoparsecConduit, authenticateOauth
, conduit, dataDefault, doctest, failure, filepath, hlint
, httpClient, httpConduit, httpTypes, lens, liftedBase
, monadControl, monadLogger, resourcet, shakespeare, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.2.1";
  sha256 = "1z0d8hwjrdw8gkww9zkn9cqv3g40my952li8pm3c164d7ywswszq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec attoparsecConduit authenticateOauth conduit
    dataDefault failure httpClient httpConduit httpTypes lens
    liftedBase monadControl monadLogger resourcet shakespeare text time
    transformers transformersBase twitterTypes
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
