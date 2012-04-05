{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, fileEmbed, httpTypes, text, transformers, unixCompat
, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.0.0";
  sha256 = "1l4wj8d5s7h52fx4bs0780rz43wmxaf5fllnj1z8iwkc7rydkydx";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash fileEmbed
    httpTypes text transformers unixCompat wai waiAppStatic yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
