{ cabal, conduit, transformers, void, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-conduit";
  version = "0.5.0.3";
  sha256 = "05rlbyxcwq952psbfp94irmygabqxyf1kkm80pwdanlaaky03nsb";
  buildDepends = [ conduit transformers void zlibBindings ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming compression/decompression via conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
