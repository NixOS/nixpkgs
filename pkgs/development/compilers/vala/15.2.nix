{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {
  name = "vala-0.15.2";

  src = fetchurl {
    url = mirror://gnome/sources/vala/0.15/vala-0.15.2.tar.xz;
    sha256 = "0g71zq6dpqrw2f40wfzdf18fdw41ymr17laqniy2kr622hkxdi8w";
  };

  buildNativeInputs = [ yacc flex pkgconfig xz ];

  buildInputs = [ glib ];

  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = "free-copyleft";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
