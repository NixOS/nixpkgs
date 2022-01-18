{ lib
, buildDunePackage
, tezos-stdlib
, tezos-p2p
, tezos-requester
, tezos-validation
, tezos-store
, tezos-workers
, tezos-test-services
# , tezos-embedded-protocol-demo-noops
, tezos-test-helpers
# , tezos-protocol-plugin-alpha
, alcotest-lwt
, crowbar
}:

buildDunePackage {
  pname = "tezos-shell";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_shell";

  propagatedBuildInputs = [
    tezos-p2p
    tezos-requester
    tezos-validation
    tezos-store
    tezos-workers
  ];

  checkInputs = [
    alcotest-lwt
    crowbar
    tezos-test-helpers
    tezos-test-services
    # tezos-embedded-protocol-demo-noops
    # tezos-protocol-plugin-alpha
  ];

  # A lot of extra deps with wide dependency cones needed
  doCheck = false;

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-shell`";
  };
}
