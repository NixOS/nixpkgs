{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca
, libiec61883, libavc1394, taglib, pulseaudio
, glib, gstreamer, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.0.3";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "92ab8bdee2e539a5302c1b0c8d460e638da33ebf89142caee210cb0c9720c68e";
  };

  configureFlags = "--disable-oss";

  buildInputs =
    [ pkgconfig glib gstreamer gst_plugins_base libavc1394 libiec61883
      aalib libcaca cairo libdv flac libjpeg libpng pulseaudio speex
      taglib bzip2
    ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
