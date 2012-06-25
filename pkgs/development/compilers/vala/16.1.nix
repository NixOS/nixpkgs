{stdenv, fetchurl, yacc, flex, pkgconfig, glib, xz}:

stdenv.mkDerivation rec {
  name = "vala-0.16.1";

  src = fetchurl {
    url = mirror://gnome/sources/vala/0.16/vala-0.16.1.tar.xz;
    sha256 = "1n708n9ixyy9qrzyv1wf4ybvcclx43ib9ki028wwpvkz6kv8zqlb";
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
