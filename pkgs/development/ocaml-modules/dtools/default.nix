{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "dtools";
<<<<<<< HEAD
  version = "0.4.5";
=======
  version = "0.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dtools";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NLQkQx3ZgxU1zvaQjOi+38nSeX+zKCXW40zOxVNekZA=";
=======
    sha256 = "1xbgnij63crikfr2jvar6sf6c7if47qarg5yycdfidip21vhmawf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-dtools";
    description = "Library providing various helper functions to make daemons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
