{ stdenv, fetchurl, pkgconfig, perl, glib }:

stdenv.mkDerivation rec {
  name = "atk-1.24.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/1.24/${name}.tar.bz2";
    sha256 = "0mjxliarzcy7iksh6v1npxsqdpc9sjj3q4wcl567asbdzdpbd803";
  };

  buildNativeInputs = [perl];
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [glib];

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
  };

}
