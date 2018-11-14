{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.9";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1kfg4q01r4mqn7dj63ifhi6pmqzbf4xax6ni6kkk81ri5kndwyvf";
  };

  prePatch = let
      debian = fetchurl {
        # When the URL disappears, it typically means that Debian has new patches
        # (probably security) and updating to new tarball will apply them as well.
        url = http://http.debian.net/debian/pool/main/t/tiff/tiff_4.0.9-6.debian.tar.xz;
        sha256 = "10yk5npchxscgsnd7ihd3bbbw2fxkl7ni0plm43c9q4nwp6ms52f";
      };
    in ''
      tar xf ${debian}
      patches="$patches $(sed 's|^|debian/patches/|' < debian/patches/series)"
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
