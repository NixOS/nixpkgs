{
  lib,
  buildDunePackage,
  ocaml-crunch,
  astring,
  cmdliner,
  cppo,
  fpath,
  result,
  tyxml,
  markup,
  yojson,
  sexplib0,
  jq,
  odoc-parser,
  ppx_expect,
  bash,
  fmt,
}:

buildDunePackage {
  pname = "odoc";
  inherit (odoc-parser) version src;

  nativeBuildInputs = [
    cppo
    ocaml-crunch
  ];
  buildInputs = [
    astring
    cmdliner
    fpath
    tyxml
    odoc-parser
    fmt
  ];

  nativeCheckInputs = [
    bash
    jq
  ];
  checkInputs = [
    markup
    yojson
    sexplib0
    jq
    ppx_expect
  ];
  doCheck = true;

  preCheck = ''
    # some run.t files check the content of patchShebangs-ed scripts, so patch
    # them as well
    find test \( -name '*.sh' -o -name 'run.t' \)  -execdir sed 's@#!/bin/sh@#!${bash}/bin/sh@' -i '{}' \;
    patchShebangs test
  '';

  meta = {
    description = "Documentation generator for OCaml";
    mainProgram = "odoc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml/odoc";
    changelog = "https://github.com/ocaml/odoc/blob/${odoc-parser.version}/CHANGES.md";
  };
}
