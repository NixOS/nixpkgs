{ lib, fetchurl, buildDunePackage
, astring, base64, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, alcotest, hex, ppx_irmin
}:

buildDunePackage {
  pname = "irmin";

  inherit (ppx_irmin) src version;

  useDune2 = true;
  minimumOCamlVersion = "4.07";

  propagatedBuildInputs = [ astring base64 digestif fmt jsonm logs ocaml_lwt ocamlgraph uri ];

  checkInputs = [ alcotest hex ppx_irmin ];
  doCheck = true;

  meta = ppx_irmin.meta // {
    description = "A distributed database built on the same principles as Git";
  };
}
