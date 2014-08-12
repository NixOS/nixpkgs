{ stdenv, fetchurl, pkgconfig, python
, gst-plugins-base, orc, bzip2
, libv4l, libdv, libavc1394, libiec61883
, libvpx, speex, flac, taglib
, cairo, gdk_pixbuf, aalib, libcaca
, libsoup, pulseaudio
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.2.4";

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
    sha256 = "1lr0yk352jrcgxadi9mvjgkli7xiwwnc15by71w5wbiw75l07jf9";
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
