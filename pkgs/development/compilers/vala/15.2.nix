{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {

  version = "0.15.2";
  name = "vala-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/vala/0.15/${name}.tar.xz";
    sha256 = "0g71zq6dpqrw2f40wfzdf18fdw41ymr17laqniy2kr622hkxdi8w";
  };

  nativeBuildInputs = [ yacc flex pkgconfig xz ];

  buildInputs = [ glib ];

  meta = {
    description = "Compiler for the GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = "free-copyleft";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.antono ];
  };
}
