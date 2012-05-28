{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, fileEmbed, httpTypes, text, transformers, unixCompat
, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.0.0.3";
  sha256 = "1nl7cf8yw5akldlrkamnkbypwnj7g1pjkx7nkmlc38jbx58izf5d";
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
