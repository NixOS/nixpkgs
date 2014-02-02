{ cabal, cprngAes, dataDefaultClass, network, socks, tls, x509
, x509Store, x509System, x509Validation
}:

cabal.mkDerivation (self: {
  pname = "connection";
  version = "0.2.0";
  sha256 = "17fzkgrjavmcxhdjj7agkx16jwpf6ql31nw1ni8gczkbp7azd0kp";
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
