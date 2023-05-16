{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "llhttp";
<<<<<<< HEAD
  version = "9.1.0";
=======
  version = "8.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${version}";
<<<<<<< HEAD
    hash = "sha256-DWRo9mVpmty/Ec+pKqPTZqwOlYJD+SmddwEui7P/694=";
=======
    hash = "sha256-pBGjcT5MiCSJI12TiH1XH5eAzIeylCdP/82L3o38BJo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_STATIC_LIBS=ON"
  ];

  meta = with lib; {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
<<<<<<< HEAD
    changelog = "https://github.com/nodejs/llhttp/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
