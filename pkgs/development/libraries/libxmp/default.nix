{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libxmp";
<<<<<<< HEAD
  version = "4.6.0";
=======
  version = "4.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Extended module player library";
    homepage    = "https://xmp.sourceforge.net/";
    longDescription = ''
      Libxmp is a library that renders module files to PCM data. It supports
      over 90 mainstream and obscure module formats including Protracker (MOD),
      Scream Tracker 3 (S3M), Fast Tracker II (XM), and Impulse Tracker (IT).
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.all;
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/libxmp/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-LTxF/lI7UJB+ieYPmjt/TMmquD7J27p3Q+r/vNyzXqY=";
=======
    sha256 = "sha256-eEfSYhEtFOhEL0TlrG7Z3bylTCUShHILVjyFKzHybnU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
