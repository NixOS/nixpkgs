{ lib, buildDunePackage, alcotest, logs, ocaml_lwt }:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src useDune2;

  propagatedBuildInputs = [ alcotest logs ocaml_lwt ];

  doCheck = true;

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
