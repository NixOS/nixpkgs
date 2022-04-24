{ lib
, buildDunePackage
, alcotest
, alcotest-lwt
, tezos-base
, tezos-event-logging-test-helpers
, tezos-stdlib
, tezos-test-helpers
}:

buildDunePackage {
  pname = "tezos-base-test-helpers";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_base/test_helpers";

  propagatedBuildInputs = [
    alcotest
    alcotest-lwt
    tezos-base
    tezos-event-logging-test-helpers
  ];

  checkInputs = [
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: base test helpers";
  };
}
