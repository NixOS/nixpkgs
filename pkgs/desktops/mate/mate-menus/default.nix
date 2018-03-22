{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection, python, mate }:

stdenv.mkDerivation rec {
  name = "mate-menus-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1w1k6kdabmabhpqvkizk1si6ri4rmspsbj0252ki834ml0dxpnhg";
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
