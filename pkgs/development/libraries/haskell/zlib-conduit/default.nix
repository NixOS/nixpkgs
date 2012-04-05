{ cabal, conduit, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.4.0";
  sha256 = "0snjvpybkdcnqzw2dkja7fvakd6fwvr29l40ghxk48bzzs2j308i";
  buildDepends = [ conduit transformers zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
