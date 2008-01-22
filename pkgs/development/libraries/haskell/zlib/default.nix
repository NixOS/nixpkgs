{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "zlib";
  version = "0.4.0.2";
  sha256 = "e6e9e51ca5b7f1685eb031f826f7865acc10cc2c8d0dfad975e0e81fd17f17ed";
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
  };
})
