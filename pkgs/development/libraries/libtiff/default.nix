{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.8";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "0419mh6kkhz5fkyl77gv0in8x4d2jpdpfs147y8mj86rrjlabmsr";
  };

  prePatch =let
      debian = fetchurl {
        url = http://snapshot.debian.org/archive/debian-debug/20170928T093547Z/pool/main/t/tiff/tiff_4.0.8-5.debian.tar.xz;
        sha256 = "11qkiliw04dmdvdd5z2lv5hh2fiwa29qbhkxvlvmb4yslnmyywha";
      };
    in ''
      tar xf '${debian}'
      patches="$patches $(cat debian/patches/series | sed 's|^|debian/patches/|')"
    '';

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://download.osgeo.org/libtiff;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
