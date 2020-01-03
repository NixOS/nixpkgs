{ stdenv, fetchurl, pkgconfig, intltool, glib, gobject-introspection, python3 }:

stdenv.mkDerivation rec {
  pname = "mate-menus";
  version = "1.22.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0kh6y76f1rhp3nr22rp93bx77wcgqnygag2ir076cqkppayjc3c0";
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
