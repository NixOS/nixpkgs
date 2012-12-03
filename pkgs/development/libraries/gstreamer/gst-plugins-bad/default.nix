{ fetchurl, stdenv, pkgconfig, glib, gstreamer, gst_plugins_base
, libdvdnav, libdvdread }:

stdenv.mkDerivation rec {
  name = "gst-plugins-bad-1.0.3";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-bad/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "2eae746be0b4c7fa2f1e057c91bd36940d7c25593ab612b707904461360031f0";
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
