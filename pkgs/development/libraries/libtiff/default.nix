{ stdenv
, fetchurl
, fetchpatch

, pkgconfig

, zlib
, libjpeg
, xz
}:

stdenv.mkDerivation rec {
  version = "4.1.0";
  pname = "libtiff";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "0d46bdvxdiv59lxnb0xz9ywm8arsr6xsapi5s6y6vnys2wjz6aax";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  patches = [
    # https://gitlab.com/libtiff/libtiff/-/merge_requests/160
    (fetchpatch {
      name = "CVE-2020-35523.1.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/712fe9f5b9795c5a3e80f38db90dad11e6a8bb6a.patch";
      sha256 = "1h4jrilnhc50qzjxljcm0471i4inwr790b1dzdf6qvwf7fqi6wky";
    })
    (fetchpatch {
      name = "CVE-2020-35523.2.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/c8d613ef497058fe653c467fc84c70a62a4a71b2.patch";
      sha256 = "01rzwf5xk5mf3j362g74h9qc45cnmqr0c14w5xj3p8mk160cd74q";
    })
    # https://gitlab.com/libtiff/libtiff/-/merge_requests/159
    (fetchpatch {
      name = "CVE-2020-35524.1.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/c6a12721b46f1a72974f91177890301730d7b330.patch";
      sha256 = "1lac51lsvap6wzdg1rssnq2adrpxd3bqrsdm40qd88mpa0g3rsfb";
    })
    (fetchpatch {
      name = "CVE-2020-35524.2.patch";
      url = "https://gitlab.com/libtiff/libtiff/-/commit/d74f56e3b7ea55c8a18a03bc247cd5fd0ca288b2.patch";
      sha256 = "0v559fpsgnmhzgjhsp7fkm3hwrfjv2042lrczd32c0yb9jbrqxvi";
    })

  ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true; # not cross;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "http://download.osgeo.org/libtiff";
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
