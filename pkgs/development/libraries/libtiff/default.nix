{ stdenv, fetchurl, zlib, libjpeg }:

let version = "3.9.6"; in

stdenv.mkDerivation rec {
  name = "libtiff-${version}";
  
  src = fetchurl {
    urls =
      [ "ftp://ftp.remotesensing.org/pub/libtiff/tiff-${version}.tar.gz"
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz"
      ];
    sha256 = "0cv8ml3fnkjx60163j69a9cklzlh8wxbvbql78s78q13as8i3fhg";
  };

  patchFlags = "-p0";

  patches =
    [ (fetchurl {
        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/tiff/files/tiff-3.9.5-CVE-2012-1173.patch?revision=1.2";
        sha256 = "07v22lbx9vlqj1f5r2fzcjcr37b97mw5ayjnisgmk4nd1yjxv5qn";
      })
    ];
  
  propagatedBuildInputs = [ zlib libjpeg ];

  enableParallelBuilding = true;

  meta = {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.libtiff.org/;
    license = "bsd";
  };
}
