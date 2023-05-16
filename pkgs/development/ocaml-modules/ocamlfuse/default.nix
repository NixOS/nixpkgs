{ lib, buildDunePackage, fetchFromGitHub, camlidl, fuse, dune-configurator }:

buildDunePackage rec {
  pname = "ocamlfuse";
<<<<<<< HEAD
  version = "2.7.1_cvs8";
=======
  version = "2.7.1_cvs7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Cm9mdYzpKnYoNyAJvjJkiDBP/O4n1JiTkhXQO3w7+hA=";
=======
    sha256 = "6nmPXZx38hBGlg+gV9nnlRpPfeSAqDj4zBPcjUNvTRo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ camlidl ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ camlidl fuse ];

  meta = {
    homepage = "https://sourceforge.net/projects/ocamlfuse";
    description = "OCaml bindings for FUSE";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
