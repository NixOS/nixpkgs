{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "zlib";
  version = "0.5.0.0"; # Haskell Platform 2009.0.0
  sha256 = "20e067cfbec87ec062ac144875a60e158ea6cf7836aac031ec367fcdd5446891";
  # TODO: find out exactly why propagated is needed here (to build other
  # packages depending on zlib):
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
  };
})
