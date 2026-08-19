{
  buildDunePackage,
  alcotest,
  logs,
  lwt,
  fmt,
  re,
  cmdliner,
}:

buildDunePackage {
  pname = "alcotest-lwt";

  inherit (alcotest) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    alcotest
    logs
    lwt
    fmt
  ];

  doCheck = true;
  checkInputs = [
    re
    cmdliner
  ];

  meta = alcotest.meta // {
    description = "Lwt-based helpers for Alcotest";
  };

}
