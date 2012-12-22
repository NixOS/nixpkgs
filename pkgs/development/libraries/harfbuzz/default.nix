{ stdenv, fetchurl, pkgconfig, glib, freetype }:

stdenv.mkDerivation rec {
  name = "harfbuzz-0.9.4";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "2572f9a810d17a735ef565115463827d075af2371ee5b68e6d77231381f4bddc";
  };

  buildInputs = [ pkgconfig glib freetype ];

  meta = {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
