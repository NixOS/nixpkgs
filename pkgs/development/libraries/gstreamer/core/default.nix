{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib 
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.4.0";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "15f68pn2b47x543ih7hj59czgzl4af14j15bgjq8ky145gf9zhr3";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib ];

  setupHook = ./setup-hook.sh;
}
