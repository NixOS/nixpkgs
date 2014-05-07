{ cabal, async, attoparsec, base64Bytestring, blazeBuilder
, byteable, conduit, conduitExtra, cryptohash, cryptohashConduit
, cssText, dataDefault, fileEmbed, filepath, hashable, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, resourcet, shakespeareCss
, systemFileio, systemFilepath, text, transformers, unixCompat
, unorderedContainers, wai, waiAppStatic, waiTest, yesodCore
, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.3";
  sha256 = "093lvg7pl71dfnr7qyfmp9r1m3bs64849k0dw4w2qb618y8wb9jh";
  buildDepends = [
    async attoparsec base64Bytestring blazeBuilder byteable conduit
    conduitExtra cryptohash cryptohashConduit cssText dataDefault
    fileEmbed filepath hashable hjsmin httpTypes mimeTypes resourcet
    shakespeareCss systemFileio systemFilepath text transformers
    unixCompat unorderedContainers wai waiAppStatic yesodCore
  ];
  testDepends = [
    async base64Bytestring byteable conduit conduitExtra cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin hspec
    httpTypes HUnit mimeTypes resourcet shakespeareCss systemFileio
    systemFilepath text transformers unixCompat unorderedContainers wai
    waiAppStatic waiTest yesodCore yesodTest
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
