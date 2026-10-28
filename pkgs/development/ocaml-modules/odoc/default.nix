{
  lib,
  ocaml,
  buildDunePackage,
  removeReferencesTo,
  ocaml-crunch,
  astring,
  cmdliner,
  cmdliner_1,
  cppo,
  fpath,
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

buildDunePackage (self: {
  pname = "odoc";
  inherit (odoc-parser) version src;

  nativeBuildInputs = [
    cppo
    ocaml-crunch
    removeReferencesTo
  ];
  buildInputs = [
    astring
    (if lib.versionAtLeast self.version "3.2.0" then cmdliner else cmdliner_1)
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

  outputs = [
    "bin"
    "lib"
    "out"
  ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib odoc
    remove-references-to -t ${ocaml} $bin/bin/odoc
    runHook postInstall
  '';

  meta = {
    description = "Documentation generator for OCaml";
    mainProgram = "odoc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocaml/odoc";
    changelog = "https://github.com/ocaml/odoc/blob/${odoc-parser.version}/CHANGES.md";
  };
})
