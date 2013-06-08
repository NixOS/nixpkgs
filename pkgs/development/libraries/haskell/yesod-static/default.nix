{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, dataDefault, fileEmbed, hspec, httpTypes
, shakespeareCss, systemFileio, systemFilepath, text, transformers
, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.2.0";
  sha256 = "18fkphk8qzshm5r0ivdvllmbmvl5q6m84zsf1g0fmridqz2xywjz";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash
    dataDefault fileEmbed httpTypes shakespeareCss systemFileio
    systemFilepath text transformers unixCompat wai waiAppStatic
    yesodCore
  ];
  testDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash
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
