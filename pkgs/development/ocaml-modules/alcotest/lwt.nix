{ lib, buildDunePackage, alcotest, logs, ocaml_lwt, fmt
, re, cmdliner
}:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src useDune2;

  propagatedBuildInputs = [ alcotest logs ocaml_lwt fmt ];

  doCheck = true;
  checkInputs = [ re cmdliner ];

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
