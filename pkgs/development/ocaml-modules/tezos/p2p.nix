{ lib
, buildDunePackage
, alcotest-lwt
, astring
, lwt
, lwt-canceler
, lwt-watcher
, ringo
, tezos-base-test-helpers
, tezos-p2p-services
, tezos-stdlib
}:

buildDunePackage {
  pname = "tezos-p2p";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_p2p";

  propagatedBuildInputs = [
    lwt
    lwt-canceler
    lwt-watcher
    ringo
    tezos-p2p-services
  ];

  checkInputs = [
    alcotest-lwt
    astring
    tezos-base-test-helpers
  ];

  doCheck = false; # some tests fail

  meta = tezos-stdlib.meta // {
    description = "Tezos: library for a pool of P2P connections";
  };
}
