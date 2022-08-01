{ lib, buildDunePackage
, astring, digestif, fmt, jsonm, logs, lwt, ocamlgraph, uri
, repr, ppx_irmin, bheap, uutf, mtime, bigstringaf, hex
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version;

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  propagatedBuildInputs = [
    astring
    digestif
    fmt
    jsonm
    logs
    lwt
    ocamlgraph
    uri
    repr
    bheap
    ppx_irmin
    uutf
    mtime
    bigstringaf
  ];

  # circular dependency on irmin-mem
  doCheck = false;

  meta = ppx_irmin.meta // {
    description = "A distributed database built on the same principles as Git";
  };
}
