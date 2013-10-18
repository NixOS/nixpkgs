{ stdenv, fetchurl, pkgconfig, perl, glib, libintlOrEmpty, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "atk-2.8.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/2.8/${name}.tar.xz";
    sha256 = "1x3dd3hg9l1j9dq70xwph13vxdp6a9wbfcnryryf1wr6c8bij9dj";
  };

  buildInputs = libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig perl ];

  propagatedBuildInputs = [ glib gobjectIntrospection /*ToDo: why propagate*/ ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Accessibility toolkit";

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
