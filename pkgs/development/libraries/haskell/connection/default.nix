{ cabal, cprngAes, dataDefaultClass, network, socks, tls, x509
, x509Store, x509System, x509Validation
}:

cabal.mkDerivation (self: {
  pname = "connection";
  version = "0.2.1";
  sha256 = "1wdjfc9lld3wkr7ncjkszmrwqp74p994ml3chymniz440xg1lxwy";
  buildDepends = [
    cprngAes dataDefaultClass network socks tls x509 x509Store
    x509System x509Validation
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-connection";
    description = "Simple and easy network connections API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
