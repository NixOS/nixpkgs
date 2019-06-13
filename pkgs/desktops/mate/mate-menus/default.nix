{ stdenv, fetchurl, pkgconfig, intltool, glib, gobject-introspection, python3 }:

stdenv.mkDerivation rec {
  name = "mate-menus-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1lkakbf2f1815c146z4xp5f0h4lim6jzr02681wbvzalc6k97v5c";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];

  buildInputs = [ glib python3 ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  meta = with stdenv.lib; {
    description = "Menu system for MATE";
    homepage = https://github.com/mate-desktop/mate-menus;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
