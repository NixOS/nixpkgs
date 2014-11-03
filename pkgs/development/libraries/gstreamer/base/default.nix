{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.4.3";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "f7b4d2b3ba2bcac485896e2c1c36459cb091ebe8b49e91635c27d40f66792d9d";
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

