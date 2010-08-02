{ stdenv, fetchurl, pkgconfig, perl, glib }:

stdenv.mkDerivation rec {
  name = "atk-1.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/1.30/${name}.tar.bz2";
    sha256 = "92b9b1213cafc68fe9c3806273b968c26423237d7b1f631dd83dc5270b8c268c";
  };

  buildInputs = [ pkgconfig perl ];
  propagatedBuildInputs = [ glib ];

  meta = {
    description = "ATK, the accessibility toolkit";

    longDescription = ''
      ATK is the Accessibility Toolkit.  It provides a set of generic
      interfaces allowing accessibility technologies such as screen
      readers to interact with a graphical user interface.  Using the
      ATK interfaces, accessibility tools have full access to view and
      control running applications.
    '';

    homepage = http://library.gnome.org/devel/atk/;

    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };

}
