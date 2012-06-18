{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "bloomfilter";
  version = "1.2.6.10";
  sha256 = "1z2jc7588fkv42dxf0dxsrgk5pmj3xapshy1vyfwipp1q6y20x4j";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/bos/bloomfilter";
    description = "Pure and impure Bloom Filter implementations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
