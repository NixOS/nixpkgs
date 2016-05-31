{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2, flex, perl
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.8.1";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "082h6r2kymgb78x6av5mxaszxlqnvr6afq935ackh914vb1anyw9";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
