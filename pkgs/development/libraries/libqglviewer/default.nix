{ stdenv, fetchurl, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  name = "libqglviewer-2.6.3";
  version = "2.6.3";

  src = fetchurl {
    url = "http://www.libqglviewer.com/src/libQGLViewer-${version}.tar.gz";
    sha256 = "00jdkyk4wg1356c3ar6nk3hyp494ya3yvshq9m57kfmqpn3inqdy";
  };

  buildInputs = [ qt4 qmake4Hook ];

  postPatch =
    ''
      cd QGLViewer
    '';

  meta = with stdenv.lib; {
    description = "C++ library based on Qt that eases the creation of OpenGL 3D viewers";
    homepage = http://libqglviewer.com/;
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
