{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.4.5";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "07ampnfa6p41s0lhia62l9h8bdx3c7vxvdz93pbx64m3wycq3gbp";
  };

  nativeBuildInputs = [
    pkgconfig python gobjectIntrospection
  ];

  buildInputs = [
    orc alsaLib libXv pango libtheora
    cdparanoia libvisual
  ];

  propagatedBuildInputs = [ gstreamer ];

  enableParallelBuilding = true;
}

