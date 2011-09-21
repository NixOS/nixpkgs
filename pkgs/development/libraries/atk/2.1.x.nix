{ stdenv, fetchurl_gnome, pkgconfig, perl, glib, xz }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "atk";
    major = "2"; minor = "1"; patchlevel = "5"; extension = "xz";
    sha256 = "005b9sq8p9ykp4f35b59si3mcbw4p9hyxps1ij4x73p07rrbf0z9";
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
