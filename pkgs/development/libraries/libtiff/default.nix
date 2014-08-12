{ stdenv, fetchurl, fetchsvn, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.3";
  patchDir = fetchsvn {
    url = svn://svn.archlinux.org/packages/libtiff/trunk;
    rev = "198247";
    sha256 = "0a47l0zkc1zz7wxg64cyjv9z1djdvfyxgmwd03znlsac4zijkcy4";
  };
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    urls =
      [ "ftp://ftp.remotesensing.org/pub/libtiff/tiff-${version}.tar.gz"
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz"
      ];
    sha256 = "0wj8d1iwk9vnpax2h29xqc2hwknxg3s0ay2d5pxkg59ihbifn6pa";
  };

  patchPhase = ''
    for p in ${patchDir}/*-{2013-4244,2012-4447,2012-4564,2013-1960,2013-1961,libjpeg-turbo}.patch; do
      patch -p1 < "$p"
    done
    (
    cd tools
    for p in ${patchDir}/*-CVE-{2013-4231,2013-4232}.patch; do
      patch -p0 < "$p"
    done
    )
    patch -p0 < ${patchDir}/${if stdenv.isDarwin then "tiff-4.0.3" else "*"}-tiff2pdf-colors.patch
  ''; # ^ sh on darwin seems not to expand globs in redirects, and I don't want to rebuild all again elsewhere

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.remotesensing.org/libtiff/;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
