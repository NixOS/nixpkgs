{ lib
, fetchFromGitLab
, buildDunePackage
, tezos-stdlib
, tezos-base
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-test-services";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_test_services";

  propagatedBuildInputs = [
    tezos-base
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: Alcotest-based test services";
  };
}
