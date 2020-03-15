{ stdenv, fetchurl, pkgconfig, gettext, glib, gobject-introspection, python3 }:

stdenv.mkDerivation rec {
  pname = "mate-menus";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1vv4j38h7mrbfrsj99k25z6y7b5dg30fzd2qnhk7pl8ca8s1jhrd";
  };

  nativeBuildInputs = [ pkgconfig gettext gobject-introspection ];

  buildInputs = [ glib python3 ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Menu system for MATE";
    homepage = "https://github.com/mate-desktop/mate-menus";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
