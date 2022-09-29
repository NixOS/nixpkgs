{ lib, buildDunePackage, alcotest, logs, lwt, fmt
, re, cmdliner_1_1
}:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src;

  propagatedBuildInputs = [ alcotest logs lwt fmt ];

  doCheck = true;
  checkInputs = [ re cmdliner_1_1 ];

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
