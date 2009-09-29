args: with args;

stdenv.mkDerivation rec {
  name = "atk-1.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/1.28/${name}.tar.bz2";
    sha256 = "11zyamivv7fcj9ap3w3bn3gm89mkni9waf51fx75zmfjh3jrznp4";
  };

  buildInputs = [pkgconfig perl];
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

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };

}
