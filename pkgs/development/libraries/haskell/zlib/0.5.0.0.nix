{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib";
  version = "0.5.0.0";
  sha256 = "20e067cfbec87ec062ac144875a60e158ea6cf7836aac031ec367fcdd5446891";
  extraLibraries = [ zlib ];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
