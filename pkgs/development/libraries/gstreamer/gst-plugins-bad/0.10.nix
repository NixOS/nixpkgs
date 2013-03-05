{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libdvdnav, libdvdread }:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-0.10.36";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "0si79dsdx06w6p48v1c5ifbjhq26p4jn8swi18ni8x6j5yd5p3rf";
  };

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base libdvdnav libdvdread ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "‘Bad’ (potentially low quality) plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
