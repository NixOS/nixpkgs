{ cabal, certificate, cprngAes, dataDefault, network, socks, tls
, tlsExtra
}:

cabal.mkDerivation (self: {
  pname = "connection";
  version = "0.1.3";
  sha256 = "13bwlbga612kc7g3m3rrdzbdv4w0glp4af9r6crwgjsmxgimrgs9";
  buildDepends = [
    certificate cprngAes dataDefault network socks tls tlsExtra
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-connection";
    description = "Simple and easy network connections API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
