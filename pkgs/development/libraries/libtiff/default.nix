{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.7";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "06ghqhr4db1ssq0acyyz49gr8k41gzw6pqb6mbn5r7jqp77s4hwz";
  };

  prePatch =let
      # https://lwn.net/Vulnerabilities/711777/ and more patched in *-6 -> *-7
      debian = fetchurl {
        url = http://http.debian.net/debian/pool/main/t/tiff/tiff_4.0.7-6.debian.tar.xz;
        sha256 = "9c9048c28205bdbeb5ba36c7a194d0cd604bd137c70961607bfc8a079be5fa31";
      };
    in ''
      tar xf '${debian}'
      patches="$patches $(cat debian/patches/series | sed 's|^|debian/patches/|')"
    '';

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://download.osgeo.org/libtiff;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
