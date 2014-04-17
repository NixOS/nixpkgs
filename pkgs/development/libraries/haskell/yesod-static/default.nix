{ cabal, async, base64Bytestring, byteable, conduit, conduitExtra
, cryptohash, cryptohashConduit, dataDefault, fileEmbed, filepath
, hjsmin, hspec, httpTypes, HUnit, mimeTypes, resourcet
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, unorderedContainers, wai, waiAppStatic, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.2.5";
  sha256 = "0n084dnvrswfqsvy5kdiq4ajfna2hwyzbb9sn2lj4s8jyiw1fs61";
  buildDepends = [
    async base64Bytestring byteable conduit conduitExtra cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin httpTypes
    mimeTypes resourcet shakespeareCss systemFileio systemFilepath text
    transformers unixCompat unorderedContainers wai waiAppStatic
    yesodCore
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
