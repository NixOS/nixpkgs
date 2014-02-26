{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconvOrEmpty, libintlOrEmpty
}:

let
  major = "0.23";
  minor = "2";
  sha256 = "0g22ss9qbm3fqhx4fxhsyfmdc5g1hgdw4dz9d37f4489kl0qf8pl";
in
stdenv.mkDerivation rec {
  name = "vala-${major}.${minor}";

  meta = {
    description = "Compiler for GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ antono iyzsong ];
  };

  src = fetchurl {
    url = "mirror://gnome/sources/vala/${major}/${name}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig flex bison libxslt ];

  buildInputs = [ glib ]
    ++ libiconvOrEmpty
    ++ libintlOrEmpty;
}
