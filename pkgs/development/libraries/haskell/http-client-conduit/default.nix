{ cabal, conduit, httpClient, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "http-client-conduit";
  version = "0.2.0.1";
  sha256 = "0fy9vkxh7hvmp9ijifq8nx6y5y92n6d3s1vdyg53ln65pclc6jn5";
  buildDepends = [ conduit httpClient resourcet transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "Frontend support for using http-client with conduit";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
