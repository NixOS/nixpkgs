{ lib
, buildDunePackage
, tezos-stdlib
, tezos-p2p-services
, alcotest-lwt
, lwt-watcher
}:

buildDunePackage {
  pname = "tezos-p2p";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-p2p-services
    lwt-watcher
  ];

  checkInputs = [
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: library for a pool of P2P connections";
  };
}
