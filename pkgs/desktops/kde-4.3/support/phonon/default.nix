{ stdenv, fetchurl, lib, cmake, qt4
, libXau, libXdmcp, libpthreadstubs
, gst_all, xineLib, automoc4}:

stdenv.mkDerivation {
  name = "phonon-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/phonon-4.3.1.tar.bz2;
    sha1 = "f7537e5280d0a4cc1348975daa7a7e45d833d45c";
  };
  includeAllQtDirs = true;
  buildInputs = [ cmake qt4 libXau libXdmcp libpthreadstubs gst_all.gstreamer gst_all.gstPluginsBase xineLib automoc4 ];
  meta = {
    description = "KDE Multimedia API";
    longDescription = "KDE Multimedia API which abstracts over various backends such as GStreamer and Xine";
    license = "LGPL";
    homepage = http://phonon.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
