{ lib, fetchurl, buildDunePackage, alcotest }:

buildDunePackage rec {
  pname = "ocaml-version";
  version = "3.4.0";

  src = fetchurl {
    url = "https://github.com/ocurrent/ocaml-version/releases/download/v${version}/ocaml-version-v${version}.tbz";
    sha256 = "sha256-2MG+tejY67dxC19DTOZqPsi3UrHk1rqHxP4nRSvbiiU=";
  };

  checkInputs = [ alcotest ];

  doCheck = true;

  minimumOCamlVersion = "4.07";
  useDune2 = true;

  meta = with lib; {
    description = "Manipulate, parse and generate OCaml compiler version strings";
    homepage = "https://github.com/ocurrent/ocaml-version";
    license = licenses.isc;
    maintainers = with maintainers; [ vbgl ];
  };
}
