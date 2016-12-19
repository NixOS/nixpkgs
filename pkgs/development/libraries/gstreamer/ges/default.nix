{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2, flex, perl
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.10.2";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "0hx7bwj8li88qq09slvdxlnfq76hr35nyjvd4ixrz5gmkpmrl5fv";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
