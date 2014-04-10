{ cabal, async, base64Bytestring, byteable, conduit, conduitExtra
, cryptohash, cryptohashConduit, dataDefault, fileEmbed, filepath
, hjsmin, hspec, httpTypes, HUnit, mimeTypes, resourcet
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, unorderedContainers, wai, waiAppStatic, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.2.4";
  sha256 = "1dpd175kd1yda2fs8zzs00j8nhdvzsgqywkkh934qz7zr7p1rawl";
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
