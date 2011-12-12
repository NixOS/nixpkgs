{stdenv, fetchurl, gmp, static ? false}:

stdenv.mkDerivation rec {
  name = "isl-0.07";             # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    url = "http://www.kotnet.org/~skimo/isl/${name}.tar.bz2";
    sha256 = "0kpxmvhrwwdygqqafqzjf9xiksq7paac2x24g9jhr3f9ajj3zkyx";
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
