{ lib, fetchurl, buildDunePackage, ocaml
, astring, cppo, fpath, result, tyxml
, markup, alcotest, yojson, sexplib, jq
, cmdliner_1_0, cmdliner_1_1
}:

let
  cmdliner = if lib.versionAtLeast ocaml.version "4.08" then  cmdliner_1_1 else cmdliner_1_0;
in

buildDunePackage rec {
  pname = "odoc";
  version = "1.5.3";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml/odoc/releases/download/${version}/odoc-${version}.tbz";
    sha256 = "0idzidmz7y10xkwcf4aih0mdvkipxk1gzi4anhnbbi2q2s0nzdzj";
  };

  useDune2 = true;

  buildInputs = [ astring cmdliner cppo fpath result tyxml ];

  checkInputs = [ alcotest markup yojson sexplib jq ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    description = "A documentation generator for OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml/odoc";
  };
}
