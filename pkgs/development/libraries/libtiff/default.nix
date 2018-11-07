{ stdenv
, fetchFromGitLab

, pkgconfig
, autogen
, autoconf
, automake
, libtool

, zlib
, libjpeg
, xz
}:

stdenv.mkDerivation rec {
  version = "2018-11-04";
  name = "libtiff-unstable-${version}";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "779e54ca32b09155c10d398227a70038de399d7d";
    sha256 = "029fmn0rdmb5gxhg83ff9j2zx3qk6wsiaiv554jq26pdc23achsp";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ pkgconfig autogen autoconf automake libtool ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  preConfigure = "./autogen.sh";

  doCheck = true; # not cross;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://download.osgeo.org/libtiff;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
