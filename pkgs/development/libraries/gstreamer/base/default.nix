{ stdenv, fetchurl, pkgconfig, python, gstreamer, gobjectIntrospection
, orc, alsaLib, libXv, pango, libtheora
, cdparanoia, libvisual
}:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.2.1";

  meta = {
    description = "Base plugins and helper libraries";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "de2444a5c150d4e4b680364d7c0414cd8b015d95b305ff65d65a17683379532f";
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
