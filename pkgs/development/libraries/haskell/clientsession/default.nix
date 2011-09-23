{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3";
  sha256 = "1f5ri7h8l3v60bj6ywhn2v3kih5lclk76qx7y6jc7nyf9499aja5";
  buildDepends = [
    base64Bytestring cereal cryptoApi cryptocipher skein
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
