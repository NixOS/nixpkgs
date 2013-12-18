{ cabal, connection, dataDefault, hspec, httpClient, httpTypes
, network, tls
}:

cabal.mkDerivation (self: {
  pname = "http-client-tls";
  version = "0.2.0.1";
  sha256 = "0wzbxah6pkglpgl4ax12crw3cl8w48b8pbasb3xkbqcxpaakvbkx";
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
