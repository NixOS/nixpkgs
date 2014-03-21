{ stdenv, fetchurl, pkgconfig, python
, gnonlin, libxml2
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.2.0";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "1n7nw8rqvwna9af55lggah44gdvfgld1igvgaya8glc37wpq89b0";
  };

  nativeBuildInputs = [ pkgconfig python ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
