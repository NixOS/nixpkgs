{ cabal, base64Bytestring, cprngAes, dataDefault, filepath
, mimeMail, network, stringsearch, text, tls
}:

cabal.mkDerivation (self: {
  pname = "smtps-gmail";
  version = "1.1.0";
  sha256 = "0zr2ndpwfnb9pkv69vx94p0vpghl0khd0wbmccjpk6hlrp6fsj66";
  buildDepends = [
    base64Bytestring cprngAes dataDefault filepath mimeMail network
    stringsearch text tls
  ];
  meta = {
    homepage = "https://github.com/enzoh/smtps-gmail";
    description = "Gmail SMTP Client";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
