{ stdenv, fetchurl, qt4, qmake4Hook, unzip, mesa_glu, gdb }:

stdenv.mkDerivation rec {
  version = "0.2.7";
  name = "qwtPlot3D-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qwtplot3d/qwtplot3d/qwtplot3d-${version}.zip";
    sha256 = "1cdvn1rgj08izb21mm6mjkd07p9s5sl955l4qpdwgn35kl9rzzwj";
  };

  patches = [ ./glu.patch  ./install.patch ];

  buildInputs = [ qt4 qmake4Hook unzip mesa_glu gdb ];

  meta = with stdenv.lib; {
    description = "A feature-rich Qt/OpenGL-based C++ programming library, providing essentially a bunch of 3D-widgets for programmers";
    homepage = http://qwtplot3d.sourceforge.net/;
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
