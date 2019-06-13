{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "yajl-2.1.0";

  src = fetchurl {
    url = https://github.com/lloyd/yajl/tarball/2.1.0;
    name = "${name}.tar.gz";
    sha256 = "0f6yrjc05aa26wfi7lqn2gslm19m6rm81b30ksllpkappvh162ji";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Yet Another JSON Library";
    longDescription = ''
      YAJL is a small event-driven (SAX-style) JSON parser written in ANSI
      C, and a small validating JSON generator.
    '';
    homepage = http://lloyd.github.com/yajl/;
    license = stdenv.lib.licenses.isc;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ z77z ];
  };
}
