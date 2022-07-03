{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "dtools";
  version = "0.4.4";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-dtools";
    rev = "v${version}";
    sha256 = "1xbgnij63crikfr2jvar6sf6c7if47qarg5yycdfidip21vhmawf";
  };

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-dtools";
    description = "Library providing various helper functions to make daemons";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
