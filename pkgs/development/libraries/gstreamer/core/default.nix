{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib 
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.2.2";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "b9f12137ab663edc6c37429b38ca7911074b9c2a829267fe855d4e57d916a0b6";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib ];
}
