{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.2.1";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "1c20zg272wgzqw4f93f1prkv9a9gdqxmf3kal29l0r2wmwhqnxpy";
  };

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
