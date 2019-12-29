{ stdenv
, fetchurl

, pkgconfig

, zlib
, libjpeg
, xz
}:

stdenv.mkDerivation rec {
  version = "4.0.10";
  pname = "libtiff";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "1r4np635gr6zlc0bic38dzvxia6iqzcrary4n1ylarzpr8fd2lic";
  };

  patches = [
    (fetchurl {
      url = "https://gitlab.com/libtiff/libtiff/commit/0c74a9f49b8d7a36b17b54a7428b3526d20f88a8.patch";
      name = "CVE-2019-6128.patch";
      sha256 = "03yvsfq6dxjd3v8ypfwz6cpz2iymqwcbawqqlmkh40dayi7fgizr";
    })
    (fetchurl {
      url = "https://gitlab.com/libtiff/libtiff/commit/802d3cbf3043be5dce5317e140ccb1c17a6a2d39.patch";
      name = "CVE-2019-7663.patch";
      sha256 = "01nq5z1l55clasy4aqr0r2rgiaxay1108vni2nzd8lx4qc5q09hx";
    })
    # Manual backport of https://gitlab.com/libtiff/libtiff/commit/1b5e3b6a23827c33acf19ad50ce5ce78f12b3773.patch
    ./CVE-2019-14973.patch
    (fetchurl {
      url = "https://gitlab.com/libtiff/libtiff/commit/4bb584a35f87af42d6cf09d15e9ce8909a839145.patch";
      name = "CVE-2019-17546.patch";
      sha256 = "1pv4zimjfv6nbvr1m4vj79267zr3f3bwza5mjyarhvm0pp7q02xx";
    })
  ];

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
