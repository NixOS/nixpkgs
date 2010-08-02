{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "zlib";
  version = "0.5.2.0"; # Haskell Platform 2010.1.0.0 and 2010.2.0.0
  sha256 = "4119fb627e0adc2b129acd86fe5724cf05a49d8de5b64eb7a6e519d3befd3b8f";
  # TODO: find out exactly why propagated is needed here (to build other
  # packages depending on zlib):
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
  };
})
