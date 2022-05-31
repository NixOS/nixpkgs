{ buildDunePackage
, irmin
, ppx_irmin
, alcotest
, mtime
, astring
, fmt
, jsonm
, logs
, lwt
, metrics-unix
, ocaml-syntax-shims
, cmdliner
, metrics
}:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [
    irmin
    ppx_irmin
    alcotest
    mtime
    astring
    fmt
    jsonm
    logs
    lwt
    metrics-unix
    ocaml-syntax-shims
    cmdliner
    metrics
  ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
