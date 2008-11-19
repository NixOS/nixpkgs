args: with args;

stdenv.mkDerivation rec {
  name = "gst-plugins-good-" + version;

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-good/${name}.tar.bz2";
    sha256 = "1ccnyzn9n2a6xjxz5srydc8bm63mjz5cxbcwbigxzqw0a033ych5";
  };

  propagatedBuildInputs = [gstPluginsBase aalib cairo flac hal libjpeg
    zlib speex libpng libdv libcaca dbus.libs libiec61883 libavc1394 ladspaH
    taglib ];
  buildInputs = [pkgconfig];

  configureFlags = "--enable-shared --disable-static --enable-ladspa";

  meta = {
    homepage = http://gstreamer.freedesktop.org;
  };
}
