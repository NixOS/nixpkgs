{ stdenv, fetchurl, pkgconfig, python, gobjectIntrospection
, gnonlin, libxml2, flex, perl
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.10.4";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "http://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "0i11b1rwkjsy9gxrf9vk9lgg8qm60ggfi5lp0ncyh4lxvh16vbgj";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python gobjectIntrospection flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 ];
}
