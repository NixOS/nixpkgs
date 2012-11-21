{ cabal, cereal, cpu, cryptoApi, cryptoPubkeyTypes, primitive
, tagged, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.6";
  sha256 = "0r2alw0in0ndaz7y9bzqigla74wbn8h1z43s2zx5rc3sq5p3rp6s";
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
