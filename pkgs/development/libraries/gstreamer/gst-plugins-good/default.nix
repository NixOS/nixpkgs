{ fetchurl, stdenv, pkgconfig, gstPluginsBase, aalib, cairo
, flac , hal, libjpeg, zlib, speex, libpng, libdv, libcaca, dbus
, libiec61883, libavc1394, ladspaH, taglib, gdbm, pulseaudio
, libsoup
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-good-0.10.14";

  src = fetchurl {
    urls = [
      "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "12kq60zdqxkshpjr76iwzykzhjaq3g1rm81nz7b0x44rrc0ms80j";
  };

  propagatedBuildInputs = [gstPluginsBase aalib cairo flac hal libjpeg
    zlib speex libpng libdv libcaca dbus.libs libiec61883 libavc1394 ladspaH
    taglib gdbm pulseaudio libsoup];
  buildInputs = [pkgconfig];

  configureFlags = "--enable-ladspa";

  meta = {
    homepage = http://gstreamer.freedesktop.org;

    description = "`Good' plug-ins for GStreamer";

    license = "LGPLv2+";
  };
}
