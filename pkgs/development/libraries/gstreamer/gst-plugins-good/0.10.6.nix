args: with args;

stdenv.mkDerivation rec {
  name = "gst-plugins-good-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2";
    sha256 = "0rid0gjj8nsk0r5yn4bz1xfsbp446r92wc6wp4099hilw6jxd74y";
  };

  propagatedBuildInputs = [gstPluginsBase aalib cairo flac hal libjpeg
    zlib speex libpng libdv libcaca dbus.libs libiec61883 libavc1394 ladspaH
    taglib ];
  buildInputs = [pkgconfig];

  configureFlags = "--enable-shared --disable-static --enable-ladspa";

  patches = [ ./tag_defines.patch ];

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
