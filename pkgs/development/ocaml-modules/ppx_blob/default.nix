{ lib, fetchurl, buildDunePackage, ocaml, alcotest, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_blob";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/johnwhitington/${pname}/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "1xmslk1mwdzhy1bydgsjlcb7h544c39hvxa8lywp8w72gaggjl16";
  };

  checkInputs = lib.optional doCheck alcotest;
  buildInputs = [ ocaml-migrate-parsetree ];
  doCheck = lib.versionAtLeast ocaml.version "4.03";

  meta = with lib; {
    homepage = "https://github.com/johnwhitington/ppx_blob";
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
