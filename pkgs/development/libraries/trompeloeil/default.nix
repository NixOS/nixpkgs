{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "trompeloeil";
<<<<<<< HEAD
  version = "45";
=======
  version = "44";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rollbear";
    repo = "trompeloeil";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-oCDsvpH9P5onME/t+o7VGttk1cHUpneODz21/0RkVkk=";
=======
    sha256 = "sha256-dZl1yJwJp7OZL3xoBbz43NWVEhrSgkDYkZB4OEydRXY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Header only C++14 mocking framework";
    homepage = "https://github.com/rollbear/trompeloeil";
    license = licenses.boost;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.unix;
  };
}
