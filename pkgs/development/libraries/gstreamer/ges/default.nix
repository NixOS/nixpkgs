{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2, flex, perl
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.14.0";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "14cdd6y9p4k603hsnyhdjw2igg855gwpx0362jmg8k1gagmr0pwd";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
