{ stdenv, fetchurl, pkgconfig, intltool, glib, gobject-introspection, python, mate }:

stdenv.mkDerivation rec {
  name = "mate-menus-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "18y4nka38dqqxycxpf7ig4vmrk4i05xqqjk4fxr1ghkj60xxyxz2";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];

  buildInputs = [ glib python ];

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
