{ stdenv, fetchurl, pkgconfig, gtk3, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = "gtkmm-3.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/3.6/${name}.tar.xz";
    sha256 = "0n93z8is5afgpqq0czr5wynr78vpv5lap3ayl4x0iv5cr3am90c8";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glibmm gtk3 atkmm cairomm pangomm ];

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

    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
