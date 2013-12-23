{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib 
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.2.1";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "a4523d2471bca6cd0059a32e3b042f50faa4dadc6439852af8b43ca3f17d1fc9";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib ];
}
