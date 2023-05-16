{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ode";
<<<<<<< HEAD
  version = "0.16.4";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/${pname}/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-cQN7goHGyGsKVXKfkNXbaXq+TL7B2BGBV+ANSOwlNGc=";
=======
  version = "0.16.3";

  src = fetchurl {
    url = "https://bitbucket.org/odedevs/${pname}/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-x0Hb9Jv8Rozilkgk5bw/kG6pVrGuNZTFDTUcOD8DxBM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Open Dynamics Engine";
    homepage = "https://www.ode.org";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 lgpl21 lgpl3 zlib ];
  };
}
