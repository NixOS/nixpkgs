{ cabal, base64Bytestring, cereal, enumerator, fileEmbed, httpTypes
, pureMD5, text, transformers, unixCompat, wai, waiAppStatic
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "0.3.1.2";
  sha256 = "0r72xspxq7122k9vird4yqqzrn6p4xgzvxid7ig62zdxjlw1p36j";
  buildDepends = [
    base64Bytestring cereal enumerator fileEmbed httpTypes pureMD5 text
    transformers unixCompat wai waiAppStatic yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
