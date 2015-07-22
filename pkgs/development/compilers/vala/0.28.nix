{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconv, libintlOrEmpty
}:

let
  major = "0.28";
  minor = "0";
  sha256 = "0zwpzhkhfk3piya14m7p2hl2vaabahprphppfm46ci91z39kp7hd";
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
