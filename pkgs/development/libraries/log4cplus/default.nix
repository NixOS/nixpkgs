{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "log4cplus";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/log4cplus-${version}.tar.bz2";
    sha256 = "sha256-ZZfeeCd15OD7qP3K2TjDcJ/YOagITEtu3648xQRuJog=";
  };

  meta = {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "Port the log4j library from Java to C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
