{ lib, fetchFromGitHub, buildDunePackage, ocaml
, cryptokit, ocamlnet, ocurl, yojson
, ounit2
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.4.4";
  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+UNFW5tmIh5dVyTDEOfOmy1j+gV4P28jlnBTdpQNAjE=";
  };

  propagatedBuildInputs = [ cryptokit ocamlnet ocurl yojson ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "OCaml client for google services";
    homepage = "https://github.com/astrada/gapi-ocaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
