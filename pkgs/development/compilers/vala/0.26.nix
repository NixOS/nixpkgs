{ stdenv, fetchurl, pkgconfig, flex, bison, libxslt
, glib, libiconv, libintlOrEmpty
}:

let
  major = "0.26";
  minor = "2";
  sha256 = "37f13f430c56a93b6dac85239084681fd8f31c407d386809c43bc2f2836e03c4";
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
