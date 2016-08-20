{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconv, libintlOrEmpty
}:

let
  major = "0.32";
  minor = "1";
  sha256 = "1ab1l44abf9fj1wznzq5956431ia136rl5049cggnk5393jlf3fx";
in
stdenv.mkDerivation rec {
  name = "vala-${major}.${minor}";

  meta = {
    description = "Compiler for GObject type system";
    homepage = "http://live.gnome.org/Vala";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ antono lethalman ];
  };

  src = fetchurl {
    url = "mirror://gnome/sources/vala/${major}/${name}.tar.xz";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig flex bison libxslt ];

  buildInputs = [ glib libiconv ]
    ++ libintlOrEmpty;

}
