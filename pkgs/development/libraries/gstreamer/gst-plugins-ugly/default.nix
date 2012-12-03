{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libmad, libdvdread, libmpeg2, libcdio, a52dec }:

stdenv.mkDerivation rec {
  name = "gst-plugins-ugly-1.0.3";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-ugly/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "b8f4cfef12201f19c53a4cde7bc4fef995740c566ea45921d4473f3714e4d8c0";
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
