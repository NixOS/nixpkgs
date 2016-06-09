{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconv, libintlOrEmpty
}:

let
  major = "0.32";
  minor = "0";
  sha256 = "0vpvq403vdd25irvgk7zibz3nw4x4i17m0dgnns8j1q4vr7am8h7";
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
