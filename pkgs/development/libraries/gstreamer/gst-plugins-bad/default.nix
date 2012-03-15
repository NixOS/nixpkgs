{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libdvdnav, libdvdread }:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-0.10.22";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-bad/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "030728gf0zjg62yng4qy9yapaffbvkziawa28rk0gspz8cpi1xyq";
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
