{ lib, fetchurl, buildDunePackage, ocaml, alcotest, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_blob";
  version = "0.7.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/johnwhitington/${pname}/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "0m616ri6kmawflphiwm6j4djds27v0fjvi8xjz1fq5ydc1sq8d0l";
  };

  checkInputs = [ alcotest ];
  buildInputs = [ ocaml-migrate-parsetree ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = with lib; {
    homepage = "https://github.com/johnwhitington/ppx_blob";
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
