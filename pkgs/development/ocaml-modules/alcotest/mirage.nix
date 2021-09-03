{ lib, buildDunePackage, alcotest, lwt, logs, mirage-clock, duration }:

buildDunePackage {
  pname = "alcotest-mirage";

  inherit (alcotest) version src useDune2;

  propagatedBuildInputs = [ alcotest lwt logs mirage-clock duration ];

  doCheck = true;

  meta = alcotest.meta // {
    description = "Mirage implementation for Alcotest";
    maintainers = with lib.maintainers; [ ulrikstrid anmonteiro ];
  };
}
