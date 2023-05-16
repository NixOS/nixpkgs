{ lib, stdenv, fetchFromGitHub, nix, cmake, pkg-config, boost }:

stdenv.mkDerivation rec {
  pname = "nix-plugins";
<<<<<<< HEAD
  version = "12.0.0";
=======
  version = "10.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "shlevy";
    repo = "nix-plugins";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-VJqLfOT7y32Jupl57YXxqeDPy0tOWi46tRLN1QUDIow=";
=======
    hash = "sha256-7Lo+YxpiRz0+ZLFDvYMJWWK2j0CyPDRoP1wAc+OaPJY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ nix boost ];

  meta = {
    description = "Collection of miscellaneous plugins for the nix expression language";
    homepage = "https://github.com/shlevy/nix-plugins";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
