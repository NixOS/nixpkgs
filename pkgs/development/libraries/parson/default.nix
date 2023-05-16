{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation {
  pname = "parson";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kgabis";
    repo = "parson";
<<<<<<< HEAD
    rev = "60c37844d7a1c97547812cac3423d458c73e60f9"; # upstream doesn't use tags
    hash = "sha256-SbM0kqRtdcz1s+pUTW7VPMY1O6zdql3bao19Rk4t470=";
=======
    rev = "3c4ee26dbb3df177a2d7b9d80e154ec435ca8c01"; # upstream doesn't use tags
    sha256 = "sha256-fz2yhxy6Q5uEPAbzMxMiaXqSYkQ9uB3A4sV2qYOekJ8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib; {
    description = "Lightweight JSON library written in C";
    homepage = "https://github.com/kgabis/parson";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
