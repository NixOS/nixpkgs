{ cabal, conduit, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.2.0";
  sha256 = "1vwan9vglj7xdna3pfw71bcfcp10s4vn6fd6wwdz7wvxrbn52gsk";
  buildDepends = [ conduit transformers zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
