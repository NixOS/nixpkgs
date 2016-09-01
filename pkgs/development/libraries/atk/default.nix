{ stdenv, fetchurl, pkgconfig, perl, glib, libintlOrEmpty, gobjectIntrospection }:

let
  ver_maj = "2.20";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "atk-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/atk/${ver_maj}/${name}.tar.xz";
    sha256 = "493a50f6c4a025f588d380a551ec277e070b28a82e63ef8e3c06b3ee7c1238f0";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "dev" ];

  buildInputs = libintlOrEmpty;

  nativeBuildInputs = [ pkgconfig perl ];

  propagatedBuildInputs = [ glib gobjectIntrospection /*ToDo: why propagate*/ ];

  #doCheck = true; # no checks in there (2.10.0)

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

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };

}
