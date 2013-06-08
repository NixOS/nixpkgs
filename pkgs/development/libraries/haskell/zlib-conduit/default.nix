{ cabal, conduit, hspec, QuickCheck, resourcet, transformers, void
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "1.0.0";
  sha256 = "0q0l4qw1f2cwjj71n4i082ba47x1xba695q8xk0ky2vw5s8cg0bv";
  buildDepends = [ conduit transformers void zlibBindings ];
  testDepends = [ conduit hspec QuickCheck resourcet transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
