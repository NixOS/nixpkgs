args: with args;

stdenv.mkDerivation rec {
  name = "gtkmm-2.18.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/2.18/${name}.tar.bz2";
    sha256 = "09d66g7i6acfy5gijml54kw5gvynmrq04zl02x2k9aixpa9xybql";
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

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
