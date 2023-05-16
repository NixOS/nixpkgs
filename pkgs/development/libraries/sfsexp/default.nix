{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sfsexp";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mjsottile";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-uAk/8Emf23J0D3D5+eUEpWLY2fIvdQ7a80eGe9i1WQ8=";
=======
    sha256 = "sha256-TCAxofSRbyIdwowhHhPn483UA+QOHkLMz0P2LIi0ncA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Small Fast S-Expression Library";
    homepage = "https://github.com/mjsottile/sfsexp";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
