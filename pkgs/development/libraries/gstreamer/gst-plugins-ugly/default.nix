{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libmad, libdvdread, libmpeg2, libcdio, a52dec }:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-0.11.92";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "51d4ebd7728787722d649984cfa4633baf84412a05962cf82fc2b20a2f944d88";
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
