{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, cmake, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-oce-0.13-dev";
  src = fetchurl {
    url = https://api.github.com/repos/tpaviot/oce/tarball/bd77743bfa0e765c3a57d116a62d75b50e1a455;
    name = "${name}.tar.gz";
    sha256 = "1w7z326la9427yb23hbalsksk6w4ma5xil4jscnvi8mk6g48wyxv";
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
