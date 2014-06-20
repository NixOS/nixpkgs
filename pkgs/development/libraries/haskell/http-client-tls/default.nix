{ cabal, connection, dataDefaultClass, hspec, httpClient, httpTypes
, network, tls
}:

cabal.mkDerivation (self: {
  pname = "http-client-tls";
  version = "0.2.1.2";
  sha256 = "08qq2d4mqdd80jb99wm4gd4bqvnrlcpblvqgn18p8bzhw1qq6siy";
  buildDepends = [
    connection dataDefaultClass httpClient network tls
  ];
  testDepends = [ hspec httpClient httpTypes ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "http-client backend using the connection package and tls library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
