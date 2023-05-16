{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "log4cpp";
<<<<<<< HEAD
  version = "1.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${pname}-${version}.tar.gz";
    sha256 = "sha256-aWETZZ5CZUBiUnSoslEFLMBDBtjuXEKgx2OfOcqQydY=";
=======
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/log4cpp/${pname}-${version}.tar.gz";
    sha256 = "07gmr3jyaf2239n9sp6h7hwdz1pv7b7aka8n06gmr2fnlmaymfrc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage    = "https://log4cpp.sourceforge.net/";
    description = "A logging framework for C++ patterned after Apache log4j";
    license     = licenses.lgpl21Plus;
    platforms   = platforms.unix;
  };
}
