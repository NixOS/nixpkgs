{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, fileEmbed, httpTypes, systemFilepath, text
, transformers, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.1.1.1";
  sha256 = "1wp3ijiwsai9npf6zl0bq3fi4rbh0qjy8bii3d178sariv7588js";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash fileEmbed
    httpTypes systemFilepath text transformers unixCompat wai
    waiAppStatic yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
