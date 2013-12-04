{ stdenv, fetchurl, pkgconfig, glib, freetype,
  icu ? null, graphite2 ? null, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "harfbuzz-0.9.12";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/harfbuzz/release/${name}.tar.bz2";
    sha256 = "19cx5y2m20rp7z5j7mwqfb4ph2g8lrri69zim44x362y4w5gfly6";
  };

  buildInputs = [ pkgconfig glib freetype ]
    ++ libintlOrEmpty;
  propagatedBuildInputs = []
    ++ (stdenv.lib.optionals (icu != null) [icu])
    ++ (stdenv.lib.optionals (graphite2 != null) [graphite2])
    ;

  meta = {
    description = "An OpenType text shaping engine";
    homepage = http://www.freedesktop.org/wiki/Software/HarfBuzz;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
