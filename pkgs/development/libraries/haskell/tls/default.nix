{ cabal, cereal, certificate, cprngAes, cryptohash, cryptoPubkey
, cryptoRandom, mtl, network, QuickCheck, testFramework
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "tls";
  version = "1.1.4";
  sha256 = "0fq6hnc3j54kkzlvcvhskjrj740p44y65fggnj3m4kgfiwjphw5p";
  buildDepends = [
    cereal certificate cryptohash cryptoPubkey cryptoRandom mtl network
  ];
  testDepends = [
    cereal certificate cprngAes cryptoPubkey cryptoRandom mtl
    QuickCheck testFramework testFrameworkQuickcheck2 time
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS/SSL protocol native implementation (Server and Client)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
