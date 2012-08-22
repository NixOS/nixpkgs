{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libmad, libdvdread, libmpeg2, libcdio, a52dec }:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-0.11.93";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "d6654430c65e620fc9bd3d471bca43993eb698fe0a0b23bab76f4fd46cccbb30";
  };

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base libmad libdvdread a52dec ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "‘Ugly’ (potentially patent-encumbered) plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
