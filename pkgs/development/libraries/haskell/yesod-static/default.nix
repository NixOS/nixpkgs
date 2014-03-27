{ cabal, async, base64Bytestring, byteable, conduit, cryptohash
, cryptohashConduit, dataDefault, fileEmbed, filepath, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, processConduit, resourcet
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, unorderedContainers, wai, waiAppStatic, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.2.3";
  sha256 = "1lxnrd2972yj3a56kz9giz15h2g9qh12pgylpsxhpvscf3xajwml";
  buildDepends = [
    async base64Bytestring byteable conduit cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin httpTypes
    mimeTypes resourcet shakespeareCss systemFileio systemFilepath text
    transformers unixCompat unorderedContainers wai waiAppStatic
    yesodCore
  ];
  testDepends = [
    async base64Bytestring byteable conduit cryptohash
    cryptohashConduit dataDefault fileEmbed filepath hjsmin hspec
    httpTypes HUnit mimeTypes processConduit resourcet shakespeareCss
    systemFileio systemFilepath text transformers unixCompat
    unorderedContainers wai waiAppStatic waiTest yesodCore yesodTest
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
