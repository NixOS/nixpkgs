{ cabal, base64Bytestring, byteable, conduit, cryptohash
, cryptohashConduit, dataDefault, fileEmbed, filepath, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, processConduit, resourcet
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, unorderedContainers, wai, waiAppStatic, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.2.2";
  sha256 = "156qqd2v3z7wv75jsfscs9cvbg1cl1riqcrhycrqcmapjprr2r12";
  buildDepends = [
    base64Bytestring byteable conduit cryptohash cryptohashConduit
    dataDefault fileEmbed filepath hjsmin httpTypes mimeTypes
    processConduit resourcet shakespeareCss systemFileio systemFilepath
    text transformers unixCompat unorderedContainers wai waiAppStatic
    yesodCore
  ];
  testDepends = [
    base64Bytestring byteable conduit cryptohash cryptohashConduit
    dataDefault fileEmbed filepath hjsmin hspec httpTypes HUnit
    mimeTypes processConduit resourcet shakespeareCss systemFileio
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
