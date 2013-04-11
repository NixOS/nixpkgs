{ stdenv, fetchurl, pkgconfig, gtk3, glibmm, cairomm, pangomm, atkmm }:

stdenv.mkDerivation rec {
  name = "gtkmm-3.7.12"; # gnome 3.8 release; stable 3.6 has problems with our new glibc

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/3.7/${name}.tar.xz";
    sha256 = "05nrilm34gid7kqlq09hcdd7942prn2vbr1qgqvdhgy4x8pvz9p9";
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
