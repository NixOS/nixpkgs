{ cabal, conduit, transformers, void, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.5.0";
  sha256 = "0mba63wx11vb9xir4fbp031ay71xv8b3rnj8gnihsxf3yqq09b99";
  buildDepends = [ conduit transformers void zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
