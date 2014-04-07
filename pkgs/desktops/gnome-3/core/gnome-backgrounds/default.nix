{ stdenv, fetchurl, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/3.12/${name}.tar.xz";
    sha256 = "77a893025a0bed5753631a810154cad53fb2cf34c8ee988016217cd8862eab42";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
