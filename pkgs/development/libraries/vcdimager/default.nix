{ stdenv, fetchurl, pkgconfig, libcdio, libxml2, popt }:

stdenv.mkDerivation {
  name = "vcdimager-0.7.24";

  src = fetchurl {
    url = mirror://gnu/vcdimager/vcdimager-0.7.24.tar.gz;
    sha256 = "1526jxynslg07i50v3c3afhc8swbd4si8y6s8m3h1wrz6mkplp87";
  };

  buildNativeInputs = [ pkgconfig ];

  buildInputs = [ libxml2 popt ];

  propagatedBuildInputs = [ libcdio ];

  meta = {
    homepage = http://www.gnu.org/software/vcdimager/;
    description = "GNU VCDImager is a full-featured mastering suite for authoring, disassembling and analyzing Video CDs and Super Video CDs.";
    platforms = stdenv.lib.platforms.gnu; # random choice
  };
}
