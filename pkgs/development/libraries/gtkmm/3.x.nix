{ stdenv, fetchurl, pkgconfig, gtk3, glibmm, cairomm, pangomm, atkmm }:

let
  ver_maj = "3.10";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "gtkmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${ver_maj}/${name}.tar.xz";
    sha256 = "0f1587pc6x8hn268vqj5zr4dvyisj5zd9zpsfxyfm1pkbjmcv9bg";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glibmm gtk3 atkmm cairomm pangomm ];

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

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [ raskin urkud vcunat ];
    platforms = stdenv.lib.platforms.linux;
  };
}
