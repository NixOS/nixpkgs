{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "zlib";
  version = "0.5.3.1"; # Haskell Platform 2011.2.0.0
  sha256 = "1hj56lk4g2zr7acdda39zib1bj02777q0asm5ms9rfj7kp81caiq";
  # TODO: find out exactly why propagated is needed here (to build other
  # packages depending on zlib):
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
  };
})
