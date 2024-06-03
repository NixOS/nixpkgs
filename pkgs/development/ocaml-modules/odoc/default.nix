{ lib, buildDunePackage, ocaml
, ocaml-crunch
, astring, cmdliner, cppo, fpath, result, tyxml
, markup, yojson, sexplib0, jq
, odoc-parser, ppx_expect, bash, fmt
}:

buildDunePackage rec {
  pname = "odoc";
  inherit (odoc-parser) version src;

  nativeBuildInputs = [ cppo ocaml-crunch ];
  buildInputs = [ astring cmdliner fpath result tyxml odoc-parser fmt ];

  nativeCheckInputs = [ bash jq ];
  checkInputs = [ markup yojson sexplib0 jq ppx_expect ];
  doCheck = lib.versionAtLeast ocaml.version "4.08"
    && lib.versionOlder yojson.version "2.0";

  preCheck = ''
    # some run.t files check the content of patchShebangs-ed scripts, so patch
    # them as well
    find test \( -name '*.sh' -o -name 'run.t' \)  -execdir sed 's@#!/bin/sh@#!${bash}/bin/sh@' -i '{}' \;
    patchShebangs test
  '';

  meta = {
    description = "A documentation generator for OCaml";
    mainProgram = "odoc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml/odoc";
    changelog = "https://github.com/ocaml/odoc/blob/${version}/CHANGES.md";
  };
}
