{ cabal, base64Bytestring, cprngAes, dataDefault, filepath
, mimeMail, network, stringsearch, text, tls
}:

cabal.mkDerivation (self: {
  pname = "smtps-gmail";
  version = "1.2.1";
  sha256 = "04sancbfbbszajgb1jp613qp43qxvzz9b14c0v3sgfva7fdhaw9q";
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
