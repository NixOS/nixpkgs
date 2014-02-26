{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, pulseaudio
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.2.3";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "0w74hms2zg0rnhilj9cbhx9wfiryrkcvhr1g90scrg8mllv3bcxz";
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [
    gst-plugins-base orc bzip2
    libv4l libdv libavc1394 libiec61883
    libvpx speex flac taglib
    cairo gdk_pixbuf aalib libcaca
    libsoup pulseaudio
  ];
}
