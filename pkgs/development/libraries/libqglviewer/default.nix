{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "libQGLViewer-2.6.3";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/${name}.tar.gz";
    sha256 = "00jdkyk4wg1356c3ar6nk3hyp494ya3yvshq9m57kfmqpn3inqdy";
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
