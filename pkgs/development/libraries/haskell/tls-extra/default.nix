{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandom, mtl, network, pem, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.6";
  sha256 = "0k0sj3nq1lrvbmd582mjj8cxbxigivz1hm8hhij1ncl2pgnq5xyv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cipherAes cipherRc4 cryptohash cryptoPubkey
    cryptoRandom mtl network pem time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
