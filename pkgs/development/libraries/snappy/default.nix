{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "snappy-1.1.1";
  
  src = fetchurl {
    url = "http://snappy.googlecode.com/files/${name}.tar.gz";
    sha256 = "1czscb5i003jg1amw3g1fmasv8crr5g3d922800kll8b3fj097yp";
  };

  # -DNDEBUG for speed
  preConfigure = ''
    configureFlagsArray=("CXXFLAGS=-DNDEBUG -O2")
  '';

  doCheck = true;

  meta = {
    homepage = http://code.google.com/p/snappy/;
    license = "BSD";
    description = "Compression/decompression library for very high speeds";
  };
}
