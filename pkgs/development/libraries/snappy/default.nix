{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "snappy-1.1.0";
  
  src = fetchurl {
    url = "http://snappy.googlecode.com/files/${name}.tar.gz";
    sha256 = "0q31cx3zkw0apx1fy8z3xlh2lvivssvykqn0vxsgm4xvi32jpa0z";
  };

  # -DNDEBUG for speed
  preConfigure = ''
    configureFlagsArray=("CXXFLAGS=-DNDEBUG -O2")
  '';

  doCheck = true;

  meta = {
    homepage = http://code.google.com/p/snappy/
    license = "BSD"
    description = "Compression/decompression library for very high speeds";
  };
}
