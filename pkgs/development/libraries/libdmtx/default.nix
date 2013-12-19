{ stdenv, fetchurl, pkgconfig, imagemagick }:

stdenv.mkDerivation rec {
  name = "libdmtx-0.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/libdmtx/${name}.tar.bz2";
    sha256 = "0xnxx075ycy58n92yfda2z9zgd41h3d4ik5d9l197lzsqim5hb5n";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ imagemagick ];

  meta = {
    description = "An open source software for reading and writing Data Matrix barcodes";
    homepage = http://libdmtx.org;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
