{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "entt";
<<<<<<< HEAD
  version = "3.12.2";
=======
  version = "3.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "skypjack";
    repo = "entt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gzoea3IbmpkIZYrfTZA6YgcnDU5EKdXF5Y7Yz2Uaj4A=";
=======
    sha256 = "sha256-/ZvMyhvnlu/5z4UHhPe8WMXmSA45Kjbr6bRqyVJH310=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/skypjack/entt";
    description = "A header-only, tiny and easy to use library for game programming and much more written in modern C++";
    maintainers = with maintainers; [ twey ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
