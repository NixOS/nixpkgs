{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.2.4";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0l35zh2cdv515zv6n4yif49y6jfxzlf73q6g7k2vr52s7zf76qjd";
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
