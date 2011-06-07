{ stdenv, fetchurl, pkgconfig, imagemagick }:

stdenv.mkDerivation rec {
  name = "libdmtx-0.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/libdmtx/${name}.tar.bz2";
    sha256 = "0iin2j3ad7ldj32dwc04g28k54iv3lrc5121rgyphm7l9hvigbvk";
  };

  buildNativeInputs = [ pkgconfig ];

  propagatedBuildInputs = [ imagemagick ];

  meta = {
    description = "An open source software for reading and writing Data Matrix barcodes";
    homepage = http://libdmtx.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
