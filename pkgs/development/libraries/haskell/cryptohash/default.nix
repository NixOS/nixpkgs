{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.7.8";
  sha256 = "0n9m5gl3hfkx0p0mg05k7317vjqqx5aynandg428pcgcjkpbfv9g";
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
