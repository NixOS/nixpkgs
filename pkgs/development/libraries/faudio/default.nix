{ lib, stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
  pname = "faudio";
<<<<<<< HEAD
  version = "23.08";
=======
  version = "23.05";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ceFnk0JQtolx7Q1FnADCO0z6fCxu1RzmN3sHohy4hzU=";
=======
    sha256 = "sha256-uZSKbLQ36Kw6useAKyDoxLKD1xtKbigq/ejWErxvkcE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [cmake];

  buildInputs = [ SDL2 ];

  meta = with lib; {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
<<<<<<< HEAD
    changelog = "https://github.com/FNA-XNA/FAudio/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };
}
