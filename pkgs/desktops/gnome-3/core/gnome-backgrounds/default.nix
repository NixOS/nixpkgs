{ stdenv, fetchurl, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/3.10/${name}.tar.xz";
    sha256 = "11rv03m4hznpx0brf47hil04199z3jjvl1aq7q0lnill3yrffiyc";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
