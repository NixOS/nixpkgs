{ cabal, base64Bytestring, cereal, pureMD5, text, transformers
, waiAppStatic, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-static";
  version = "0.1.0.1";
  sha256 = "0icb1wp0ndvl54shjyv0apmias60j2gjbcv7i92dxnl3fzx74d3p";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring cereal pureMD5 text transformers waiAppStatic
    yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Static file serving subsite for Yesod Web Framework.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
