{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, fileEmbed, httpTypes, systemFilepath, text
, transformers, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.1.1";
  sha256 = "01y9na79p57h43iyad27k0zrpc3ky76kwp1kyhvp0kb7rm4zib2k";
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
