{ stdenv, fetchurl }:

let
  name = "log4cplus-1.0.4";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "c2bb01b5f4bff5fa768700e98ead4a79dfd556096c9f3f0401849da7ab80fbef";
  };

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "a port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
  };
}
