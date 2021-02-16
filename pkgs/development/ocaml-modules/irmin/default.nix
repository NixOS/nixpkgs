{ lib, buildDunePackage
, astring, base64, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, repr, ppx_irmin, bheap
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version;

  useDune2 = true;
  minimumOCamlVersion = "4.07";

  propagatedBuildInputs = [
    astring
    base64
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
  ];

  # circular dependency on irmin-mem
  doCheck = false;

  meta = ppx_irmin.meta // {
    description = "A distributed database built on the same principles as Git";
  };
}
