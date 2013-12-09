{ cabal, connection, dataDefault, hspec, httpClient, httpTypes
, network, tls
}:

cabal.mkDerivation (self: {
  pname = "http-client-tls";
  version = "0.2.0.0";
  sha256 = "06ywjmhdgnwdyfj0qvmabb5bvgrdfyf7dfxm0hzqvkh2i104s7g0";
  buildDepends = [ connection dataDefault httpClient network tls ];
  testDepends = [ hspec httpClient httpTypes ];
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "http-client backend using the connection package and tls library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
