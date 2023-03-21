{ lib, fetchurl, buildDunePackage, ocaml
, astring, cmdliner, cppo, fpath, result, tyxml
, markup, yojson, sexplib0, jq
, odoc-parser, ppx_expect, bash, fmt
}:

buildDunePackage rec {
  pname = "odoc";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/ocaml/odoc/releases/download/${version}/odoc-${version}.tbz";
    sha256 = "sha256-9XTb0ozQ/DorlVJcS7ld320fZAi7T+EhV/pTeIT5h/0=";
  };

  # dune 3 is required for tests to pass
  duneVersion = if doCheck then "3" else "2";

  nativeBuildInputs = [ cppo ];
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
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml/odoc";
  };
}
