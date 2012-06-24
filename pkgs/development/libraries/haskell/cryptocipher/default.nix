{ cabal, cereal, cpu, cryptoApi, cryptoPubkeyTypes, primitive
, tagged, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.5";
  sha256 = "02qc1rr9l51dnk0sn7js8zv2w2qhkha3ik828j5s729h80cyw99s";
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
