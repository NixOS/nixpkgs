{ fetchurl, stdenv, pkgconfig, gst_plugins_base, aalib, cairo
, flac, libjpeg, zlib, speex, libpng, libdv, libcaca
, libiec61883, libavc1394, taglib, pulseaudio
, glib, gstreamer, bzip2
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-1.0.5";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.xz"
      "mirror://gentoo/distfiles/${name}.tar.xz"
      ];
    sha256 = "1i8b2kap50pz5m3iq4hf23jjbx3cwn5lxjj84nrg35kqis20pgak";
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
