{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohashCryptoapi, dataDefault, fileEmbed, filepath, hjsmin
, hspec, httpTypes, HUnit, mimeTypes, processConduit, resourcet
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, unorderedContainers, wai, waiAppStatic, waiTest
, yesodCore, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.2.1";
  sha256 = "1dsr3gv6hf42islw2018y4yajvkd9j627fkdlz45309cyjns55jg";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohashCryptoapi
    dataDefault fileEmbed filepath hjsmin httpTypes mimeTypes
    processConduit resourcet shakespeareCss systemFileio systemFilepath
    text transformers unixCompat unorderedContainers wai waiAppStatic
    yesodCore
  ];
  testDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohashCryptoapi
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
