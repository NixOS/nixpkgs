{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection, python }:

stdenv.mkDerivation rec {
  name = "mate-menus-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "03fwv0fvg073dmdbrcbpwjhxpj98aqna804m9nqybhvj3cfyhaz6";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ glib gobjectIntrospection python ];

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
