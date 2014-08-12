{ stdenv, fetchurlGnome, pkgconfig, gtk, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "gtkmm";
    major = "2"; minor = "24"; patchlevel = "4"; extension = "xz";
    sha256 = "1vpmjqv0aqb1ds0xi6nigxnhlr0c74090xzi15b92amlzkrjyfj4";
  };

  nativeBuildInputs = [pkgconfig];

  propagatedBuildInputs = [ glibmm gtk atkmm cairomm pangomm ];

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
    platforms = stdenv.lib.platforms.linux;
  };
}
