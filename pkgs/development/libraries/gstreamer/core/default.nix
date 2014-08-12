{ stdenv, fetchurl, pkgconfig, perl, bison, flex, python, gobjectIntrospection
, glib 
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.2.4";

  meta = {
    description = "Open source multimedia framework";
    homepage = "http://gstreamer.freedesktop.org";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "0aa93cqzrhm1z7rkzk343p251ifvih0d0l8xsng2ra3hg1xacz0y";
  };

  nativeBuildInputs = [
    pkgconfig perl bison flex python gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib ];

  setupHook = ./setup-hook.sh;
}
