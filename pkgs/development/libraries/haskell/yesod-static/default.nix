{ cabal, base64Bytestring, cereal, fileEmbed, httpTypes, pureMD5
, text, transformers, unixCompat, wai, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "0.3.0.1";
  sha256 = "1dvg60kawmvczwxvkxzx5k19y36i23fi0faw71ck58mlkjdczby5";
  buildDepends = [
    base64Bytestring cereal fileEmbed httpTypes pureMD5 text
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
