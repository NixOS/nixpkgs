{ cabal, conduit, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.4.0.1";
  sha256 = "07x0fgzxnwaaw5yg1ks2w9dc66biqbg50x79h84jpgb6d9pw2d7z";
  buildDepends = [ conduit transformers zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
