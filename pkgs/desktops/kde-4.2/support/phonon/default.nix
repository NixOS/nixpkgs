{stdenv, fetchurl, cmake,
libXau, libXdmcp,
qt4, pthread_stubs,
gst_all, xineLib,
automoc4}:

stdenv.mkDerivation {
  name = "phonon-4.3.0";
  src = fetchurl {
    url = mirror://kde/stable/phonon/4.3.0/phonon-4.3.0.tar.bz2;
    md5 = "f851219ec1fb4eadc7904f053b6b498d";
  };
  buildInputs = [ cmake
                  libXau libXdmcp
                  qt4 pthread_stubs gst_all.gstreamer gst_all.gstPluginsBase xineLib
		  automoc4 ];
}
