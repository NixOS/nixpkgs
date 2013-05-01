{ cabal, base64Bytestring, cereal, conduit, cryptoConduit
, cryptohash, fileEmbed, hspec, httpTypes, systemFilepath, text
, transformers, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "1.1.2.3";
  sha256 = "15wk7kpr5xdxia07wyx7msfdlyafqn2pkkrzzdfqvij972n17xmh";
  buildDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash fileEmbed
    httpTypes systemFilepath text transformers unixCompat wai
    waiAppStatic yesodCore
  ];
  testDepends = [
    base64Bytestring cereal conduit cryptoConduit cryptohash fileEmbed
    hspec httpTypes systemFilepath text transformers unixCompat wai
    waiAppStatic yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
