{ stdenv, fetchurl }:

let
  name = "log4cplus-2.0.4";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/${name}.tar.bz2";
    sha256 = "0lh2i22znx573jchcfy4n5lrr9yjg2hd3iphhlih61zzmd67p2hc";
  };

  meta = {
    homepage = http://log4cplus.sourceforge.net/;
    description = "A port the log4j library from Java to C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
