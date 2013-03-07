{ stdenv, fetchurl_gnome, pkgconfig, gtk, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gtkmm";
    major = "2"; minor = "24"; patchlevel = "2"; extension = "xz";
    sha256 = "0gcm91sc1a05c56kzh74l370ggj0zz8nmmjvjaaxgmhdq8lpl369";
  };

  nativeBuildInputs = [pkgconfig];

  propagatedBuildInputs = [ glibmm gtk atkmm cairomm pangomm ];

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

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
