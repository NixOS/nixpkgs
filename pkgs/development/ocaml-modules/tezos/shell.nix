{ lib
, buildDunePackage
, tezos-stdlib
, tezos-p2p
, tezos-requester
, tezos-validation
, tezos-store
, lwt-canceler
, alcotest-lwt
, qcheck-alcotest
, tezos-base-test-helpers
, tezos-embedded-protocol-demo-noops
, tezos-protocol-plugin-alpha
, tezos-test-helpers
}:

buildDunePackage {
  pname = "tezos-shell";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_shell";

  propagatedBuildInputs = [
    lwt-canceler
    tezos-p2p
    tezos-requester
    tezos-store
    tezos-validation
  ];

  checkInputs = [
    alcotest-lwt
    qcheck-alcotest
    tezos-base-test-helpers
    tezos-embedded-protocol-demo-noops
    tezos-protocol-plugin-alpha
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-shell`";
  };
}
