{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "log4cpp";
  version = "1.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${pname}-${version}.tar.gz";
    sha256 = "sha256-aWETZZ5CZUBiUnSoslEFLMBDBtjuXEKgx2OfOcqQydY=";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage    = "https://log4cpp.sourceforge.net/";
    description = "Logging framework for C++ patterned after Apache log4j";
    mainProgram = "log4cpp-config";
    license     = licenses.lgpl21Plus;
    platforms   = platforms.unix;
  };
}
