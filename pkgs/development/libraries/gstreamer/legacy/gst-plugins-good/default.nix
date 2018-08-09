{ fetchurl, stdenv, lib, pkgconfig, gst-plugins-base, aalib, cairo
, flac, libjpeg, speex, libpng, libdv, libcaca, libvpx
, taglib, libpulseaudio, gdk_pixbuf, orc
, glib, gstreamer, bzip2, libsoup, libshout, ncurses, libintl
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

  configureFlags = [ "--enable-experimental" "--disable-oss" ];

  buildInputs =
    [ pkgconfig glib gstreamer gst-plugins-base libintl ]
    ++ lib.optional stdenv.isLinux libpulseaudio
    ++ lib.optionals (!minimalDeps)
      [ aalib libcaca cairo libdv flac libjpeg libpng speex
        taglib bzip2 libvpx gdk_pixbuf orc libsoup libshout ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString (!minimalDeps) ''
    substituteInPlace $out/lib/gstreamer-0.10/libgstaasink.la \
      --replace "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  # fails 1 out of 65 tests with "Could not read TLS certificate from '../../tests/files/test-cert.pem': TLS support is not available"
  doCheck = false;

  meta = {
    homepage = https://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
