{ cabal, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandomApi
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.1.2";
  sha256 = "1law5l7j0r0v89dnibmaipjp0yshffq10xs4rvg2j247v29lhns5";
  buildDepends = [
    cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandomApi
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey";
    description = "Public Key cryptography";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
