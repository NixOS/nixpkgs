{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, pulseaudio
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.2.2";

  meta = {
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "6c090f00e8e4588f12807bd9fbb06a03b84a512c93e84d928123ee4a42228a81";
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
