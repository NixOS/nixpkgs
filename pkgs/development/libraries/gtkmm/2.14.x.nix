{ stdenv, fetchurl, pkgconfig, gtk, atk, glibmm, cairomm, pangomm }:

stdenv.mkDerivation rec {
  name = "gtkmm-2.14.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/2.14/${name}.tar.bz2";
    sha256 = "18jral2lv9jv02d3balh0mi0wgbqhrz5y2laclri1skccc2q3c94";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [ glibmm gtk atk cairomm pangomm ];

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
  };
}
