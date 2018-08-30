{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libmspack-0.7.1alpha";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/libmspack/${name}.tar.gz";
    sha256 = "0zn4vwzk5ankgd0l88cipan19pzbzv0sm3fba17lvqwka3dp1acp";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = https://www.cabextract.org.uk/libmspack;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
