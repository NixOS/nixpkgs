{ buildDunePackage, irmin, ppx_irmin, mtime, astring, fmt, jsonm, logs, lwt
, metrics-unix, ocaml-syntax-shims, cmdliner, metrics, alcotest-lwt
, hex, vector, qcheck-alcotest
}:

buildDunePackage {

  pname = "irmin-test";

  inherit (irmin) version src;

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

  doCheck = true;
  checkInputs = [ hex qcheck-alcotest vector ];

  meta = irmin.meta // {
    description = "Irmin test suite";
  };

}
