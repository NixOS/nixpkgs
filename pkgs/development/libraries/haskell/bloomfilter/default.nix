{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "bloomfilter";
  version = "1.2.6.10";
  sha256 = "162vp9riwf5q2l1hnw3g157fpwnw185fk41hkgyf8qaavcrz6slv";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/bos/bloomfilter";
    description = "Pure and impure Bloom Filter implementations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
