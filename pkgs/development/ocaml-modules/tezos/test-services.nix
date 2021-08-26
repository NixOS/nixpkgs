{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-test-services";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-base
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: Alcotest-based test services";
  };
}
