{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "digest";
  version = "0.0.0.9";
  sha256 = "15gj3iq3jm4lnkc6hnj9v8p8ia3yzbsajwf9by3b1kpl449k2h29";
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
