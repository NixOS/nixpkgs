{ stdenv, fetchurl, lib, cmake, qt4
, libXau, libXdmcp, libpthreadstubs
, gst_all, xineLib, automoc4}:

stdenv.mkDerivation {
  name = "phonon-4.3.80";
  src = fetchurl {
    url = mirror://kde/unstable/phonon/phonon-4.3.80.tar.bz2;
    sha256 = "1v4ba2ddphkv0gjki5das5brd1wp4nf5ci73c7r1pnyp8mgjkjw9";
  };
  includeAllQtDirs=true;
  NIX_CFLAGS_COMPILE = "-I${gst_all.gstPluginsBase}/include/${gst_all.prefix}";
  buildInputs = [ cmake qt4 libXau libXdmcp libpthreadstubs gst_all.gstreamer gst_all.gstPluginsBase xineLib automoc4 ];
  meta = {
    description = "KDE Multimedia API";
    longDescription = "KDE Multimedia API which abstracts over various backends such as GStreamer and Xine";
    license = "LGPL";
    homepage = http://phonon.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
