{stdenv, fetchurl, libGLU_combined, tcl, tk, file, libXmu, cmake, libtool, qt4,
ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-oce-0.17.2";
  src = fetchurl {
    url = https://github.com/tpaviot/oce/archive/OCE-0.17.2.tar.gz;
    sha256 = "0vpmnb0k5y2f7lpmwx9pg9yfq24zjvnsak5alzacncfm1hv9b6cd";
  };

  buildInputs = [ libGLU_combined tcl tk file libXmu libtool qt4 ftgl freetype cmake ];

  # Fix for glibc 2.26
  postPatch = ''
    sed -i -e 's/^\( *#include <\)x\(locale.h>\)//' \
      src/Standard/Standard_CLocaleSentry.hxx
  '';

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DOCE_INSTALL_PREFIX=$out"
  '';

  # https://bugs.freedesktop.org/show_bug.cgi?id=83631
  NIX_CFLAGS_COMPILE = "-DGLX_GLXEXT_LEGACY";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
