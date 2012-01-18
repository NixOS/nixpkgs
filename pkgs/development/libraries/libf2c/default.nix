{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "libf2c";
  
  src = fetchurl {
    url = http://www.netlib.org/f2c/libf2c.zip;
    sha256 = "14py0zdwzj5gqjzi0z2hlcy3czpzx1fav55akdj143qgav8h6dav";
  };

  unpackPhase = ''
    mkdir build
    cd build
    unzip ${src}
  '';

  makeFlags = "-f makefile.u";

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp libf2c.a $out/lib
    cp f2c.h $out/include
  '';

  buildInputs = [ unzip ];

  meta = {
    description = "F2c converts Fortran 77 source code to C";
    homepage = http://www.netlib.org/f2c/;
    license = "BSD";
  };
}
