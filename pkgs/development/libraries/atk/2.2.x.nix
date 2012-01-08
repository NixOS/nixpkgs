{ stdenv, fetchurl, pkgconfig, perl, glib, xz }:

stdenv.mkDerivation rec {
  name = "atk-2.2.0";

  src = fetchurl {
    url = mirror://gnome/sources/atk/2.2/atk-2.2.0.tar.xz;
    sha256 = "17bkqg89l9hxbkgc76cxlin1bwczk7m6ikbccx677lrxh3kz08lb";
  };

  buildNativeInputs = [ pkgconfig perl xz ];

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
