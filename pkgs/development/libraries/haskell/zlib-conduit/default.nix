{ cabal, conduit, transformers, void, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.5.0.2";
  sha256 = "1jgj3x4z1901bm1618753hqyrjragzrpyhy9h02qj9kplqswh878";
  buildDepends = [ conduit transformers void zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
