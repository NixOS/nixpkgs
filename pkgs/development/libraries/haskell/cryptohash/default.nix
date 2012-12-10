{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.7.10";
  sha256 = "02qvjic4xnljimpd156q28gmqf3g8m0hgijn18rx7digilqjmsgl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
