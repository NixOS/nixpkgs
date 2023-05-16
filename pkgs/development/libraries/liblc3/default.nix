{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:

let
  name = "liblc3";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  pname = name;
  version = version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "liblc3";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nQJgF/cWoCx5TkX4xOaLB9SzvhVXPY29bLh7UwPMWEE=";
=======
    sha256 = "sha256-Be+dPUnxC2+cHzqL2FAqXOU7NjEAHiPBKh7spuYkvhc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    description = "LC3 (Low Complexity Communication Codec) is an efficient low latency audio codec";
    homepage = "https://github.com/google/liblc3";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jansol ];
  };
}

