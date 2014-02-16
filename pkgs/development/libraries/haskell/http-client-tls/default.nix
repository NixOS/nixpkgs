{ cabal, connection, dataDefaultClass, hspec, httpClient, httpTypes
, network, tls
}:

cabal.mkDerivation (self: {
  pname = "http-client-tls";
  version = "0.2.1.1";
  sha256 = "07kwcamc100y48gghmlfvj5ycf6y3cynqqg5kx0ymgjk85k7vim7";
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
