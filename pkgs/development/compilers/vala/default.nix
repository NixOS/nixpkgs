{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconvOrEmpty, libintlOrEmpty
}:

let
  major = "0.23";
  minor = "1";
  sha256 = "1m8f2d01r4jqp266mk29qsl68lzh7c258cqd5zzbpbryxszlzdfj";
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
