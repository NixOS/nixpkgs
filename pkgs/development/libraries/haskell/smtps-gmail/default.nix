{ cabal, base64Bytestring, cprngAes, dataDefault, filepath
, mimeMail, network, stringsearch, text, tls
}:

cabal.mkDerivation (self: {
  pname = "smtps-gmail";
  version = "1.1.1";
  sha256 = "1ccj9rmbplh0c7h6rpg3ry213nb1lrhf7hm2vl7kq9lv0nb7cy97";
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
