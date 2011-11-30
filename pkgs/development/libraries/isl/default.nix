{stdenv, fetchurl, gmp, static ? false}:

stdenv.mkDerivation rec {
  name = "isl-0.08";

  src = fetchurl {
    url = "http://www.kotnet.org/~skimo/isl/${name}.tar.bz2";
    sha256 = "16rqvajcp9x6j76mg9q6bprqkgsm1zprx50j90s6v996y7ww3j9l";
  };

  buildInputs = [ gmp ];

  dontDisableStatic = static;
  configureFlags =
    stdenv.lib.optionals static [ " --enable-static" "--disable-shared" ];

  meta = {
    homepage = http://www.kotnet.org/~skimo/isl/;
    license = "LGPLv2.1";
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints.";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.all;
  };
}
