{ stdenv, fetchurl, pkgconfig, perl, glib }:

stdenv.mkDerivation rec {
  name = "atk-1.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/1.32/${name}.tar.bz2";
    sha256 = "e9a3e598f75c4db1af914f8b052dd9f7e89e920a96cc187c18eb06b8339cb16e";
  };

  buildInputs = [ pkgconfig perl ];
  propagatedBuildInputs = [ glib ];

  postInstall = "rm -rf $out/share/gtk-doc";
  
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
