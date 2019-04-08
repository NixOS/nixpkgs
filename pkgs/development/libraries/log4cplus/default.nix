{ stdenv, fetchurl }:

let
  name = "log4cplus-2.0.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "0rwzwskvv94cqg2nn7jsvzlak7y01k37v345fcm040klrjvkbc3w";
  };

  meta = {
    homepage = http://log4cplus.sourceforge.net/;
    description = "A port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
