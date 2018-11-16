{ stdenv, fetchurl }:

let
  name = "log4cplus-2.0.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "0y9yy32lhgrcss8i2gcc9incdy55rcrr16dx051gkia1vdzfkay4";
  };

  meta = {
    homepage = http://log4cplus.sourceforge.net/;
    description = "A port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
