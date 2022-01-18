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
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_requester";

  propagatedBuildInputs = [
    tezos-base
    lwt-watcher
  ];

  checkInputs = [
    alcotest-lwt
    tezos-test-services
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: generic resource fetching service";
  };
}
