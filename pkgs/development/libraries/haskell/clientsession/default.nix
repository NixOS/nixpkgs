{ cabal, base64Bytestring, cryptoApi, cryptocipher }:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.0";
  sha256 = "08a6k0dqx9qp7j87iq6kmyzg1aw8ykc7vrbzdbr1lfkwh05dvglm";
  buildDepends = [ base64Bytestring cryptoApi cryptocipher ];
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Store session data in a cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
