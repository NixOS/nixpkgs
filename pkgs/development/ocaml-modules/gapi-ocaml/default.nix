{ lib, fetchFromGitHub, buildDunePackage, ocaml
, cryptokit, ocamlnet, ocurl, yojson
, ounit2
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+UNFW5tmIh5dVyTDEOfOmy1j+gV4P28jlnBTdpQNAjE=";
=======
    sha256 = "sha256-V0GB9Bd06IdcI5PDFHGVZ0Y/qi7tTs/4ITqPXUOxCLs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ cryptokit ocamlnet ocurl yojson ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "OCaml client for google services";
<<<<<<< HEAD
    homepage = "https://github.com/astrada/gapi-ocaml";
=======
    inherit (src.meta) homepage;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
