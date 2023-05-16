{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "osqp";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "oxfordcontrol";
    repo = "osqp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-enkK5EFyAeLaUnHNYS3oq43HsHY5IuSLgsYP0k/GW8c=";
=======
    sha256 = "sha256-RYk3zuZrJXPcF27eMhdoZAio4DZ+I+nFaUEg1g/aLNk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A quadratic programming solver using operator splitting";
    homepage = "https://osqp.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ taktoa ];
    platforms = platforms.all;
  };
}
