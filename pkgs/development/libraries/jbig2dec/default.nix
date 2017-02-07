{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jbig2dec-0.13";

  src = fetchurl {
    url = "http://downloads.ghostscript.com/public/jbig2dec/${name}.tar.gz";
    sha256 = "04akiwab8iy5iy34razcvh9mcja9wy737civ3sbjxk4j143s1b2s";
  };

  meta = {
    homepage = https://www.ghostscript.com/jbig2dec.html;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
