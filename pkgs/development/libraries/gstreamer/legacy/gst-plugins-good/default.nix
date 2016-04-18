{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca, libvpx
, libiec61883, libavc1394, taglib, libpulseaudio, gdk_pixbuf, orc
, glib, gstreamer, bzip2, libsoup, libshout, ncurses, libintlOrEmpty
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
    [ pkgconfig glib gstreamer gst_plugins_base ]
    ++ stdenv.lib.optional stdenv.isLinux [ libpulseaudio ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optionals (!minimalDeps)
      [ aalib libcaca cairo libdv flac libjpeg libpng speex
        taglib bzip2 libvpx gdk_pixbuf orc libsoup libshout ];

  NIX_LDFLAGS = if stdenv.isDarwin then "-lintl" else null;

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace $out/lib/gstreamer-0.10/libgstaasink.la \
      --replace "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
