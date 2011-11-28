{ cabal, base64Bytestring, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.5";
  sha256 = "0j5vwlmc9vz2zrwpjfjxfz1hl94zc1dbs8jm55dnd6c043i5ag4w";
  buildDepends = [
    base64Bytestring cereal cprngAes cryptoApi cryptocipher entropy
    skein
  ];
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
