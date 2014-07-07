{ cabal, aeson, attoparsec, authenticateOauth, caseInsensitive
, conduit, conduitExtra, dataDefault, doctest, filepath, hlint
, hspec, httpClient, httpConduit, httpTypes, lens, monadControl
, monadLogger, network, resourcet, shakespeare, text, time
, transformers, transformersBase, twitterTypes
}:

cabal.mkDerivation (self: {
  pname = "twitter-conduit";
  version = "0.0.5.1";
  sha256 = "0wmr5124s6n0xdilzh2cd693ar2i0mwkgsik9ns1d34ibnvfibgv";
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
