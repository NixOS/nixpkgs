{ cabal, aeson, attoparsec, attoparsecConduit, authenticateOauth
, conduit, dataDefault, doctest, failure, filepath, hlint
, httpClient, httpConduit, httpTypes, lens, liftedBase
, monadControl, monadLogger, resourcet, shakespeare, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.3";
  sha256 = "0snhy5xbdr4iy3mmm04i7sqz6fycw8hd50vndf527fncm9vr65wb";
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
