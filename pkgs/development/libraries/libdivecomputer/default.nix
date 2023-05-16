{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdivecomputer";
<<<<<<< HEAD
  version = "0.8.0";

  src = fetchurl {
    url = "https://www.libdivecomputer.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-J17M55I2RO1YH6q53LTxpprSUbzrByHE5fhftjFheg4=";
=======
  version = "0.7.0";

  src = fetchurl {
    url = "https://www.libdivecomputer.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-gNnxlOokUCA535hZhILgr8aw4zPeeds0wpstaJNNJbk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.libdivecomputer.org";
    description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
    maintainers = [ maintainers.mguentner ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
