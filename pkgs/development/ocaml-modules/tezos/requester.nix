{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, lwt-watcher
, alcotest-lwt
, qcheck-alcotest
, tezos-base-test-helpers
, tezos-test-helpers
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
    qcheck-alcotest
    tezos-base-test-helpers
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: generic resource fetching service";
  };
}
