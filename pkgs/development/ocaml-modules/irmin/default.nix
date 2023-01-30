{ lib, buildDunePackage
, astring, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, repr, ppx_irmin, bheap, uutf, mtime, lwt, optint
, vector, hex, alcotest, qcheck-alcotest
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version strictDeps;

  minimalOCamlVersion = "4.08";

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

  nativeCheckInputs = [
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
