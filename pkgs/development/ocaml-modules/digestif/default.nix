{ lib, ocaml, fetchurl, buildDunePackage
, eqaf
, alcotest, astring, bos, findlib, fpath
}:

buildDunePackage rec {
  pname = "digestif";
  version = "1.1.3";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-${version}.tbz";
    hash = "sha256-wyuOy8QLImRa49bjhrucnFqy/eEwolLplLGOsNWAyS4=";
  };

  propagatedBuildInputs = [ eqaf ];

  checkInputs = [ alcotest astring bos fpath ];
  doCheck = true;

  postCheck = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ test/test_runes.ml
  '';

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
