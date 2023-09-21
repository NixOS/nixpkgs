{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "log4cplus";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/log4cplus-${version}.tar.bz2";
    sha256 = "sha256-oElFrKX7wEh1A8hSvvuc3vvDrj/mFLCKkFMz9t91Q4c=";
  };

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "A port the log4j library from Java to C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
