{ cabal, connection, dataDefault, hspec, httpClient, httpTypes
, network, tls
}:

cabal.mkDerivation (self: {
  pname = "http-client-tls";
  version = "0.2.0.2";
  sha256 = "0v5730rssddc28f1q6ndkcjrfz8r5a1wmxk1azpmdxlq6nh4i9q9";
  buildDepends = [ connection dataDefault httpClient network tls ];
  testDepends = [ hspec httpClient httpTypes ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "http-client backend using the connection package and tls library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
