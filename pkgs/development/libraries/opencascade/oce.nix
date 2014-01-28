{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, cmake, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-oce-0.14.1";
  src = fetchurl {
    url = https://github.com/tpaviot/oce/archive/OCE-0.14.1.tar.gz;
    sha256 = "0pfc94nmzipm6zmxywxbly1cpfr6wadxasqqkkbdvzg937mrwl5d";
  };

  buildInputs = [ mesa tcl tk file libXmu libtool qt4 ftgl freetype cmake ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DOCE_INSTALL_PREFIX=$out"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
