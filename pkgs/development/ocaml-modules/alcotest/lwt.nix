{ lib, buildDunePackage, alcotest, logs, ocaml_lwt, fmt
, re, cmdliner_1_1
}:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src useDune2;

  propagatedBuildInputs = [ alcotest logs ocaml_lwt fmt ];

  doCheck = true;
  checkInputs = [ re cmdliner_1_1 ];

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
