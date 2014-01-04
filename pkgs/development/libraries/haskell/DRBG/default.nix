{ cabal, cereal, cipherAes128, cryptoApi, cryptohashCryptoapi
, entropy, mtl, parallel, prettyclass, tagged
}:

cabal.mkDerivation (self: {
  pname = "DRBG";
  version = "0.5.1";
  sha256 = "0mqgll5rf0h0yrdng1w9i8pis4yv9f4qffkh4c0g1ng5lxa9l747";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cipherAes128 cryptoApi cryptohashCryptoapi entropy mtl
    parallel prettyclass tagged
  ];
  meta = {
    description = "Deterministic random bit generator (aka RNG, PRNG) based HMACs, Hashes, and Ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
