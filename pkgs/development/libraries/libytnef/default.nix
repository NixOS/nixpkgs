{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libytnef";
<<<<<<< HEAD
  version = "2.1.2";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kQb45Da0T7wWi1IivA8Whk+ECL2nyFf7Gc0gK1HKj2c=";
=======
    sha256 = "sha256-VlgvbU8yNHyVRKqaNqqCpLBsndltfAk33BuzvFuViqU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
