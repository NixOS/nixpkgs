{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.9";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1kfg4q01r4mqn7dj63ifhi6pmqzbf4xax6ni6kkk81ri5kndwyvf";
  };

  prePatch = let
      debian = fetchurl {
        url = http://snapshot.debian.org/archive/debian-debug/20180128T155203Z//pool/main/t/tiff/tiff_4.0.9-3.debian.tar.xz;
        sha256 = "0wya42y7kcq093g3h7ca10cm5sns1mgnkjmdd2qdi59v8arga4y4";
      };
    in ''
      tar xf '${debian}'
      patches="$patches $(cat debian/patches/series | sed 's|^|debian/patches/|')"
    '';

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true; # not cross;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://download.osgeo.org/libtiff;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
