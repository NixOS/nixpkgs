{ lib, buildDunePackage
, astring, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, repr, ppx_irmin, bheap, uutf, mtime
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version strictDeps;

  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    astring
    digestif
    fmt
    jsonm
    logs
    ocaml_lwt
    ocamlgraph
    uri
    repr
    bheap
    ppx_irmin
    uutf
    mtime
  ];

  # circular dependency on irmin-mem
  doCheck = false;

  meta = ppx_irmin.meta // {
    description = "A distributed database built on the same principles as Git";
  };
}
