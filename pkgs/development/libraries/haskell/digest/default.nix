{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "digest";
  version = "0.0.1.1";
  sha256 = "1m04szf9yabmm6mkjq2x7a57bjdf2i611wm2k99wdcygb5cvif3v";
  extraLibraries = [ zlib ];
  meta = {
    description = "Various cryptographic hashes for bytestrings; CRC32 and Adler32 for now";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
