{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  name = "libtommath-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/libtom/libtommath/releases/download/v${version}/ltm-${version}.tar.xz";
    sha256 = "0sbccdwbkfc680id2fi0x067j23biqcjqilwkk7y9339knrjy0s7";
  };

  nativeBuildInputs = [ libtool ];

  postPatch = ''
    substituteInPlace makefile.shared --replace "LT:=glibtool" "LT:=libtool"
    substituteInPlace makefile_include.mk --replace "shell arch" "shell uname -m"
  '';

  preBuild = ''
    makeFlagsArray=(PREFIX=$out \
      INSTALL_GROUP=$(id -g) \
      INSTALL_USER=$(id -u))
  '';

  makefile = "makefile.shared";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libtom.net/LibTomMath/;
    description = "A library for integer-based number-theoretic applications";
    license = with licenses; [ publicDomain wtfpl ];
    platforms = platforms.unix;
  };
}
