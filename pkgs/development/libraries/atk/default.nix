{ stdenv, fetchurl, pkgconfig, perl, glib, libintlOrEmpty, gobjectIntrospection }:

let
  ver_maj = "2.10";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "atk-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/${ver_maj}/${name}.tar.xz";
    sha256 = "1c2hbg66wfvibsz2ia0ri48yr62751fn950i97c53j3b0fjifsb3";
  };

  buildInputs = libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig perl ];

  propagatedBuildInputs = [ glib gobjectIntrospection /*ToDo: why propagate*/ ];

  #doCheck = true; # no checks in there (2.10.0)

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
