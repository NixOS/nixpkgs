{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, pulseaudio
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.4.3";

  meta = with stdenv.lib; {
    description = "Gstreamer Good Plugins";
    homepage    = "http://gstreamer.freedesktop.org";
    longDescription = ''
      a set of plug-ins that we consider to have good quality code,
      correct functionality, our preferred license (LGPL for the plug-in
      code, LGPL or LGPL-compatible for the supporting library).
    '';
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz";
    sha256 = "5876a74402f2a24d1d3ae9163c32466bdc7a565696dddeef65e6a9a93efc5537";
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
