{ fetchurl, stdenv, pkgconfig, gstPluginsBase, aalib, cairo
, flac , hal, libjpeg, zlib, speex, libpng, libdv, libcaca, dbus
, libiec61883, libavc1394, ladspaH, taglib, gdbm, pulseaudio
, libsoup, libcap, libtasn1
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.24";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1gnhw86yx0362hvmnihiq5d7i710ag9zlg636dlcdvxqqp4slx7j";
  };

  propagatedBuildInputs = [gstPluginsBase aalib cairo flac hal libjpeg
    zlib speex libpng libdv libcaca dbus.libs libiec61883 libavc1394 ladspaH
    taglib gdbm pulseaudio libsoup libcap libtasn1];
  buildInputs = [pkgconfig];

  configureFlags = "--enable-ladspa";

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;

    license = "LGPLv2+";
  };
}
