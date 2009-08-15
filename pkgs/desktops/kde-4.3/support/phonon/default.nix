{ stdenv, fetchurl, cmake
, libXau, libXdmcp,
, qt4, pthread_stubs
, gst_all, xineLib
, automoc4}:

stdenv.mkDerivation {
  name = "phonon-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/phonon-4.3.1.tar.bz2;
    sha1 = "f7537e5280d0a4cc1348975daa7a7e45d833d45c";
  };
  includeAllQtDirs = true;
  buildInputs = [ cmake
                  libXau libXdmcp
                  qt4 pthread_stubs gst_all.gstreamer gst_all.gstPluginsBase xineLib
		  automoc4 ];
}
