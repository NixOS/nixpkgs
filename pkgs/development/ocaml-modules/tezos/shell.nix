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
    tezos-test-helpers
    # tezos-demo-noops.embedded-protocol
    # tezos-alpha.protocol-plugin
  ];

  # We're getting infinite recursion from the function that creates the protocol packages
  # If we want to enable this we need to split that function again, but it seems worth it to skip this test
  doCheck = false;

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-shell`";
  };
}
