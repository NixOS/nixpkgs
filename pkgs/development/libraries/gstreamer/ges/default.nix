{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.4.0";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "1cwbh244an6zsxsscvg6xjnb34ylci34g9zx59xjbv5wnw7vj86c";
  };

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
