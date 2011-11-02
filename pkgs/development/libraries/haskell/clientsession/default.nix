{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.3";
  sha256 = "0cfj225hzn8fsffwnq5zq55dh9m5av1i58b4njhna7miiz6b4jsq";
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
