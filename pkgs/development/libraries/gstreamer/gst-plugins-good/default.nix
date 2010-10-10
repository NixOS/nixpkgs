{ fetchurl, stdenv, pkgconfig, gstPluginsBase, aalib, cairo
, flac , hal, libjpeg, zlib, speex, libpng, libdv, libcaca, dbus
, libiec61883, libavc1394, ladspaH, taglib, gdbm, pulseaudio
, gnome, libcap, libtasn1, liboil
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.20";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "11x3irvfm9v96rkyh0ajdqd94y4xhshd98lb2zapf7wykq7pyjrw";
  };

  propagatedBuildInputs = [gstPluginsBase aalib cairo flac hal libjpeg
    zlib speex libpng libdv libcaca dbus.libs libiec61883 libavc1394 ladspaH
    taglib gdbm pulseaudio gnome.libsoup libcap libtasn1 liboil];
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
