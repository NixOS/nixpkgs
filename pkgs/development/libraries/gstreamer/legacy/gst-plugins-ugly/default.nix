{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libmad, libdvdread, libmpeg2, libcdio, a52dec, x264, orc }:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-0.10.19";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1w4d5iz9ffvh43l261zdp997i6s2iwd61lflf755s3sw4xch1a8w";
  };

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base libmad libdvdread a52dec x264 orc ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "‘Ugly’ (potentially patent-encumbered) plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
