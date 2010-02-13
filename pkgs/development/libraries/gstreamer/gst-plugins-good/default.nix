{ fetchurl, stdenv, pkgconfig, gstPluginsBase, aalib, cairo
, flac , hal, libjpeg, zlib, speex, libpng, libdv, libcaca, dbus
, libiec61883, libavc1394, ladspaH, taglib, gdbm, pulseaudio
, libsoup, libcap, libtasn1, ...
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.18";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "1fabn9h4z1p4h35nrw9fyjhcnl1z6cnikmpcb9q6fd312mr8hfqj";
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
