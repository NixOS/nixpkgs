{stdenv, fetchurl, pkgconfig, m4}:

stdenv.mkDerivation rec {
  name = "libsigc++-1.2.7";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/1.2/${name}.tar.bz2";
    sha256 = "099224v5y0y1ggqrfc8vga8afr3nb93iicn7cj8xxgsrwa83s5nr";
  };

  buildInputs = [pkgconfig m4];

  meta = {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
    branch = "1.2";
    platforms = stdenv.lib.platforms.unix;
  };
}
