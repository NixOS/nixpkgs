{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "gtkdatabox-0.9.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${name}.tar.gz";
    sha256 = "0h20685bzw5j5h6mw8c6apbrbrd9w518c6xdhr55147px11nhnkl";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gtk2 ];

  meta = {
    description = "Gtk+ widget for displaying large amounts of numerical data";

    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
