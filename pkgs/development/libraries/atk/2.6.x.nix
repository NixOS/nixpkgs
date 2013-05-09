{ stdenv, fetchurl, pkgconfig, perl, glib }:

stdenv.mkDerivation rec {
  name = "atk-2.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/2.6/${name}.tar.xz";
    sha256 = "eff663f90847620bb68c9c2cbaaf7f45e2ff44163b9ab3f10d15be763680491f";
  };

  nativeBuildInputs = [ pkgconfig perl ];

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

    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.linux;
  };

}
