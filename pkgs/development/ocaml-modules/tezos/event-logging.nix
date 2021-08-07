{ lib
, buildDunePackage
, tezos-stdlib
, tezos-lwt-result-stdlib
, lwt_log
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-event-logging";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-lwt-result-stdlib
    lwt_log
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: event logging library";
  };
}
