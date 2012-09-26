{ cabal, conduit, transformers, void, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.5.0.1";
  sha256 = "138wag9fjq3hx48nzr0nvvclcyjwcd0ykjbbgms2h9msmz9vflk5";
  buildDepends = [ conduit transformers void zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
