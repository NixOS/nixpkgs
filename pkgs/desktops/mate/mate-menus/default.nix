{ stdenv, fetchurl, pkgconfig, intltool, glib, gobject-introspection, python, mate }:

stdenv.mkDerivation rec {
  name = "mate-menus-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "168f7jgm4kbnx92xh3iqvvrgpkv1q862xg27zxg40nkz5xhk95hx";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ glib gobject-introspection python ];

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
