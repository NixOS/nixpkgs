{ cabal, cereal, cpu, cryptoApi, cryptoPubkeyTypes, primitive
, tagged, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.7";
  sha256 = "14qhi3969q1h9n85flb7wwsr50gdn63q7pmcpm2npy5vkp34lkp5";
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
