{ lib
, buildDunePackage
, tezos-stdlib
, tezos-p2p-services
, tezos-test-services
, alcotest-lwt
, astring
, lwt-watcher
}:

buildDunePackage {
  pname = "tezos-p2p";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_p2p";

  propagatedBuildInputs = [
    tezos-p2p-services
    lwt-watcher
  ];

  checkInputs = [
    astring
    alcotest-lwt
    tezos-test-services
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library for a pool of P2P connections";
  };
}
