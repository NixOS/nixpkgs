{ cabal, cereal, certificate, cryptohash, cryptoPubkey
, cryptoRandomApi, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.1.1";
  sha256 = "0ji83b5z3v6f6a6rgyj5xkjh9vvsqckr7ymzjnhb4zqf0mgymypq";
  buildDepends = [
    cereal certificate cryptohash cryptoPubkey cryptoRandomApi mtl
    network
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
