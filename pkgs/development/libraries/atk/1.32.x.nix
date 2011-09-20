{ stdenv, fetchurl_gnome, pkgconfig, perl, glib }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "atk";
    major = "1"; minor = "32"; patchlevel = "0";
    sha256 = "0vmikhrvh1pb31y1ik4n1a99xs7pv4nhb2sgj6pv2kawyycfb8z9";
  };

  buildNativeInputs = [ pkgconfig perl ];

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
