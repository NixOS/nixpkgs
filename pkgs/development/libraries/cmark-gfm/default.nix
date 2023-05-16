{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cmark-gfm";
<<<<<<< HEAD
  version = "0.29.0.gfm.13";
=======
  version = "0.29.0.gfm.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "github";
    repo = "cmark-gfm";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-HiSGtRsSbW03R6aKoMVVFOLrwP5aXtpeXUC/bE5M/qo=";
=======
    sha256 = "sha256-2jkMJcfcOH5qYP13qS5Hutbyhhzq9WlqlkthmQoJoCM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    description = "GitHub's fork of cmark, a CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/github/cmark-gfm";
    changelog = "https://github.com/github/cmark-gfm/raw/${version}/changelog.txt";
    maintainers = with maintainers; [ cyplo ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
