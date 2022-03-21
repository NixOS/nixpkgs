{ lib, fetchFromGitHub, buildDunePackage, ocaml
, cryptokit, ocamlnet, ocurl, yojson
, ounit
}:

buildDunePackage rec {
  pname = "gapi-ocaml";
  version = "0.4.2";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-imicHOlNjPHHW/lcWRJmURafYZFe/6J3efKPJcel8J8=";
  };

  propagatedBuildInputs = [ cryptokit ocamlnet ocurl yojson ];

  doCheck = lib.versionAtLeast ocaml.version "4.04";
  checkInputs = [ ounit ];

  meta = {
    description = "OCaml client for google services";
    homepage = "http://gapi-ocaml.forge.ocamlcore.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
