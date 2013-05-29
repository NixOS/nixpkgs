{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "digest";
  version = "0.0.1.2";
  sha256 = "04gy2zp8yzvv7j9bdfvmfzcz3sqyqa6rwslqcn4vyair2vmif5v4";
  extraLibraries = [ zlib ];
  meta = {
    description = "Various cryptographic hashes for bytestrings; CRC32 and Adler32 for now";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
