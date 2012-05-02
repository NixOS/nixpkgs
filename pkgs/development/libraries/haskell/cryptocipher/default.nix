{ cabal, cereal, cpu, cryptoApi, cryptoPubkeyTypes, primitive
, tagged, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.1";
  sha256 = "14icn1p0mjg4y45q6pbh8qamw5hm1z2z7d424gmiknbf24nq8nmi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cpu cryptoApi cryptoPubkeyTypes primitive tagged vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptocipher";
    description = "Symmetrical Block, Stream and PubKey Ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
