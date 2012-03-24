{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib";
  version = "0.5.2.0";
  sha256 = "4119fb627e0adc2b129acd86fe5724cf05a49d8de5b64eb7a6e519d3befd3b8f";
  extraLibraries = [ zlib ];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
