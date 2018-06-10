{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "gtkdatabox-0.9.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${name}.tar.gz";
    sha256 = "1wigd4bdlrz4pma2l2wd3z8sx7pqmsvq845nya5vma9ibi96nhhz";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gtk2 ];

  meta = {
    description = "Gtk+ widget for displaying large amounts of numerical data";

    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
