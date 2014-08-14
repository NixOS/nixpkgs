{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca, libvpx
, libiec61883, libavc1394, taglib, pulseaudio, gdk_pixbuf, orc
, glib, gstreamer, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.31";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1ijswgcrdp243mfsyza31fpzq6plz40p4b83vkr2x4x7807889vy";
  };

  patches = [ ./v4l.patch ];

  configureFlags = "--disable-oss";

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base libavc1394 libiec61883
      aalib libcaca cairo libdv flac libjpeg libpng pulseaudio speex
      taglib bzip2 libvpx gdk_pixbuf orc
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
