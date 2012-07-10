{ stdenv, fetchurl, pkgconfig, perl, gnome3 }:

stdenv.mkDerivation rec {
  versionMajor = "2.5";
  versionMinor = "3";
  name = "atk-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/${versionMajor}/atk-${versionMajor}.${versionMinor}.tar.xz";
    sha256 = "04v3hzdgp2cajpgkbgr36wlxcdbpzzywyl6g2fhhyjgm9vrqw4dc";
  };

  buildNativeInputs = [ pkgconfig perl ];

  propagatedBuildInputs = [ gnome3.glib ];

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

    maintainers = with stdenv.lib.maintainers; [ raskin urkud antono ];
    platforms = stdenv.lib.platforms.linux;
  };

}
