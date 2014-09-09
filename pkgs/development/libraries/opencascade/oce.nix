{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, cmake, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-oce-0.16";
  src = fetchurl {
    url = https://github.com/tpaviot/oce/archive/OCE-0.16.tar.gz;
    sha256 = "05bmg1cjz827bpq8s0hp96byirm4c3zc9vx26qz76kjsg8ry87w4";
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
