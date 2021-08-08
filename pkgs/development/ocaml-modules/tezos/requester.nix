{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, tezos-test-services
, lwt-watcher
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-requester";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-base
    lwt-watcher
  ];

  checkInputs = [
    alcotest-lwt
    tezos-test-services
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: generic resource fetching service";
  };
}
