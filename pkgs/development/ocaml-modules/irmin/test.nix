{ buildDunePackage, irmin, ppx_irmin, mtime, astring, fmt, jsonm, logs, lwt
, metrics-unix, ocaml-syntax-shims, cmdliner, metrics, alcotest-lwt
, hex, vector
}:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src strictDeps;
  duneVersion = "3";

  nativeBuildInputs = [ ppx_irmin ];

  propagatedBuildInputs = [
    irmin
    ppx_irmin
    alcotest-lwt
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

  checkInputs = [ hex vector ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
