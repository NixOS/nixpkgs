{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-inttrie";
  version = "0.0.8";
  sha256 = "0lzp89lq4gb84rcxqi77yarggz94a206da456208rrr7rhlqxg2x";
  meta = {
    homepage = "http://github.com/luqui/data-inttrie";
    description = "A lazy, infinite trie of integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
