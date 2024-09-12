{ lib, fetchurl, buildDunePackage, ocaml, alcotest, ppxlib }:

buildDunePackage rec {
  pname = "ppx_blob";
  version = "0.9.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/johnwhitington/${pname}/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "sha256-8RXpCl8Qdc7cnZMKuRJx+GcOzk3uENwRR6s5uK+1cOQ=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ ppxlib ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    homepage = "https://github.com/johnwhitington/ppx_blob";
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
