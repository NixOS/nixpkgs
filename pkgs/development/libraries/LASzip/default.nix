<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, fixDarwinDylibNames
}:

stdenv.mkDerivation (finalAttrs: {
=======
{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "3.4.3";
  pname = "LASzip";

  src = fetchFromGitHub {
    owner = "LASzip";
    repo = "LASzip";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-9fzal54YaocONtguOCxnP7h1LejQPQ0dKFiCzfvTjCY=";
=======
    rev = version;
    sha256 = "09lcsgxwv0jq50fhsgfhx0npbf1zcwn3hbnq6q78fshqksbxmz7m";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = {
    description = "Turn quickly bulky LAS files into compact LAZ files without information loss";
    homepage = "https://laszip.org";
<<<<<<< HEAD
    changelog = "https://github.com/LASzip/LASzip/releases/tag/${finalAttrs.src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.michelk ];
    platforms = lib.platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
