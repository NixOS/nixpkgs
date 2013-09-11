{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohashCryptoapi, dataDefault, fileEmbed, hspec, httpTypes
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.0.1";
  sha256 = "1ij0j1m9j6l63rl4zdfik36a3sb3k0zpqjg85sgis6wdqr18gsi5";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohashCryptoapi
    dataDefault fileEmbed httpTypes shakespeareCss systemFileio
    systemFilepath text transformers unixCompat wai waiAppStatic
    yesodCore
  ];
  testDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohashCryptoapi
    dataDefault fileEmbed hspec httpTypes shakespeareCss systemFileio
    systemFilepath text transformers unixCompat wai waiAppStatic
    yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
