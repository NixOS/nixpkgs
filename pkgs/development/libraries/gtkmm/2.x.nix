{ stdenv, fetchurl, pkgconfig, gtk2, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = "gtkmm-${minVer}.4";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${minVer}/${name}.tar.xz";
    sha256 = "1vpmjqv0aqb1ds0xi6nigxnhlr0c74090xzi15b92amlzkrjyfj4";
  };

  nativeBuildInputs = [pkgconfig];

  propagatedBuildInputs = [ glibmm gtk2 atkmm cairomm pangomm ];

  doCheck = true;

  meta = {
    description = "C++ interface to the GTK+ graphical user interface library";

    longDescription = ''
      gtkmm is the official C++ interface for the popular GUI library
      GTK+.  Highlights include typesafe callbacks, and a
      comprehensive set of widgets that are easily extensible via
      inheritance.  You can create user interfaces either in code or
      with the Glade User Interface designer, using libglademm.
      There's extensive documentation, including API reference and a
      tutorial.
    '';

    homepage = http://gtkmm.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ raskin vcunat ];
    platforms = stdenv.lib.platforms.unix;
  };
}
