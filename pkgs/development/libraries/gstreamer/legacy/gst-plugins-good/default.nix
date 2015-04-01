{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca, libvpx
, libiec61883, libavc1394, taglib, pulseaudio, gdk_pixbuf, orc
, glib, gstreamer, bzip2, libsoup
, # Whether to build no plugins that have external dependencies
  # (except the PulseAudio plugin).
  minimalDeps ? false
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

  patches = [ ./v4l.patch ./linux-headers-3.9.patch ];

  configureFlags = "--enable-experimental --disable-oss";

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base pulseaudio ]
    ++ stdenv.lib.optionals (!minimalDeps)
      [ aalib libcaca cairo libdv flac libjpeg libpng speex
        taglib bzip2 libvpx gdk_pixbuf orc libsoup ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
