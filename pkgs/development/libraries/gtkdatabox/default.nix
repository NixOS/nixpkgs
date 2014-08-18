{ stdenv, fetchurl, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "gtkdatabox-0.9.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${name}.tar.gz";
    sha256 = "90ff9fc20ea1541dfe75ae04ff98e02c3aa7ad1735d8f0e3b3352910a3f7427c";
  };

  patches = [ ./deprecated_GTK.patch ];

  buildInputs = [ pkgconfig gtk ];

  propagatedBuildInputs = [ gtk ];

  meta = {
    description = "Gtk+ widget for displaying large amounts of numerical data";

    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
