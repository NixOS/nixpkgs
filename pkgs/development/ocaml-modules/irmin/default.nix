{ lib, buildDunePackage
, astring, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, repr, ppx_irmin, bheap, uutf, mtime, lwt, optint
, vector, hex, alcotest, qcheck-alcotest
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version;

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    astring
    bheap
    digestif
    fmt
    jsonm
    logs
    lwt
    mtime
    ocamlgraph
    optint
    ppx_irmin
    repr
    uri
    uutf
  ];

  checkInputs = [
    vector
    hex
    alcotest
    qcheck-alcotest
  ];

  doCheck = true;

  meta = ppx_irmin.meta // {
    description = "A distributed database built on the same principles as Git";
  };
}
