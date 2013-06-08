{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {

  version = "0.16.1";
  name = "vala-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/vala/0.16/${name}.tar.xz";
    sha256 = "1n708n9ixyy9qrzyv1wf4ybvcclx43ib9ki028wwpvkz6kv8zqlb";
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
