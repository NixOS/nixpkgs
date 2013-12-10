{ cabal, conduit, httpClient, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "http-client-conduit";
  version = "0.2.0.0";
  sha256 = "1pb47mms5qfi185nrz675if4pb7xji97xdqpmyrplqaxqygwih1y";
  buildDepends = [ conduit httpClient resourcet transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "Frontend support for using http-client with conduit";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
