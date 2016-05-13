{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2, flex, perl
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.8.0";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "1gisdfa91kq89bsmbvb47alaxh8lpqmr6f3dzlwmf389nkandw2h";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
