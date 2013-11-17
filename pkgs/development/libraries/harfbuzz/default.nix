{ stdenv, fetchurl, pkgconfig, glib, freetype, cairo, icu
, graphite2 ? null, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "harfbuzz-0.9.24";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "08i46xx92hvz2br2d9hdxjgi0g5jglwf5bdfsandxb0qlgc5vwpd";
  };

  buildInputs = [ pkgconfig glib freetype cairo icu ] # recommended by upstream
    ++ libintlOrEmpty;
  propagatedBuildInputs = []
    ++ stdenv.lib.optional (graphite2 != null) graphite2
    ;

  meta = {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
