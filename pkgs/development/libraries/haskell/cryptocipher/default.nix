{ cabal, cereal, cpu, cryptoApi, cryptoPubkeyTypes, primitive
, tagged, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.2";
  sha256 = "0nw7rwlnakdslzg4z6ik9hfylwnrbn103n677w0xr5b81wj19a5j";
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
