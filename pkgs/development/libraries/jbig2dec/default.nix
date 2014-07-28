{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jbig2dec-0.11";

  src = fetchurl {
    url = "mirror://sourceforge/jbig2dec/${name}.tar.xz";
    sha256 = "1xddc30garsg5j8p348cz5l8vn8j7723c0sykv0kc1w5ihaghsq1";
  };

  meta = {
    homepage = http://jbig2dec.sourceforge.net/;
    description = "Decoder implementation of the JBIG2 image compression format";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
