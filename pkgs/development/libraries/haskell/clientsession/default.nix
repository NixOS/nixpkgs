{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.1";
  sha256 = "0q16brla4m5g7dmgln3awx964ms7pi1s2r21idmc0mk4rnw2rpi7";
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
