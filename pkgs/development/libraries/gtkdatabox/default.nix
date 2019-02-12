{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "gtkdatabox-0.9.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/gtkdatabox/${name}.tar.gz";
    sha256 = "1rdxnjgh6v3yjqgsfmamyzpfxckzchps4kqvvz88nifmd7ckhjfh";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ gtk2 ];

  meta = {
    description = "Gtk+ widget for displaying large amounts of numerical data";

    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
