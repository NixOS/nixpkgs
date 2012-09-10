{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca
, libiec61883, libavc1394, taglib, pulseaudio
, glib, gstreamer, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.11.93";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "6ef9b537284f0cd9e727d31f36eef907333d16e7deb6d61a93df738f00c5c93c";
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
