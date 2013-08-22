{ cabal, byteable, securemem }:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-types";
  version = "0.0.2";
  sha256 = "1vjf9g1w7ja8x42k6hq6pcw7jvviw9rq512ncdqd7j20411zjbf4";
  buildDepends = [ byteable securemem ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
