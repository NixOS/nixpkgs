{ lib, buildDunePackage, alcotest, logs, lwt, fmt
, re, cmdliner
}:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src;

  propagatedBuildInputs = [ alcotest logs lwt fmt ];

  doCheck = true;
  nativeCheckInputs = [ re cmdliner ];

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
