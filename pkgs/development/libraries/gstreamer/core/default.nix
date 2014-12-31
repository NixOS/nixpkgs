{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.4.5";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "1bmhbhak6i5wmmb6w86jyyv8lax4gdq983la4lk4a0krz6kim020";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib ];

  setupHook = ./setup-hook.sh;
}
