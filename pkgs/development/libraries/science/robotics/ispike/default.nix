{ lib, stdenv, fetchurl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "ispike";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/ispike/${pname}-${version}.tar.gz";
    sha256 = "0khrxp43bi5kisr8j4lp9fl4r5marzf7b4inys62ac108sfb28lp";
  };

<<<<<<< HEAD
  postPatch = ''
    sed -i "1i #include <map>" include/iSpike/YarpConnection.hpp
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  meta = {
    description = "Spiking neural interface between iCub and a spiking neural simulator";
    homepage = "https://sourceforge.net/projects/ispike/";
    license = lib.licenses.lgpl3;
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = lib.platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ lib.maintainers.nico202 ];
  };
}
