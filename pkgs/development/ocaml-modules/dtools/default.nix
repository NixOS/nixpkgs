{
  lib,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "dtools";
  version = "0.4.5";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dtools";
    rev = "v${version}";
    sha256 = "sha256-NLQkQx3ZgxU1zvaQjOi+38nSeX+zKCXW40zOxVNekZA=";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-dtools";
    description = "Library providing various helper functions to make daemons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
