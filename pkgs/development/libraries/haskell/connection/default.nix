{ cabal, certificate, cprngAes, dataDefault, network, socks, tls
, tlsExtra
}:

cabal.mkDerivation (self: {
  pname = "connection";
  version = "0.1.3.1";
  sha256 = "1z9vb20466lg7l8z4abfbsdzpix18hswpqcl7s2gv838s2wvd16w";
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
