{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "libQGLViewer-2.3.4";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/${name}.tar.gz";
    sha256 = "01b9x2n3v5x3zkky2bjpgbhn5bglqn4gd7x5j5p7y2dw0jnzz7j0";
  };

  buildInputs = [ qt4 ];

  buildPhase =
    ''
      cd QGLViewer
      qmake PREFIX=$out
      make
    '';

  meta = { 
    description = "trackball-based 3D viewer qt widget including many useful features";
    homepage = http://artis.imag.fr/Members/Gilles.Debunne/QGLViewer/installUnix.html;
    license = stdenv.lib.licenses.gpl2;
  };
}
