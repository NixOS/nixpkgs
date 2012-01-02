{ cabal, base64Bytestring, cereal, enumerator, fileEmbed, httpTypes
, pureMD5, text, transformers, unixCompat, wai, waiAppStatic
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "0.3.2.1";
  sha256 = "0gggavj5bxb12axlfl8kmqizgg55nmcrr6z5za60n3bp70sq4vn4";
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
