{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.2.3";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "1qfs4lv91ggcck61pw0ybn3gzvx4kl2vsd6lp8l6ky3hq8syrvb1";
  };

  nativeBuildInputs = [
    pkgconfig python gobjectIntrospection
  ];

  buildInputs = [
    orc alsaLib libXv pango libtheora
    cdparanoia libvisual
  ];

  propagatedBuildInputs = [ gstreamer ];
}
