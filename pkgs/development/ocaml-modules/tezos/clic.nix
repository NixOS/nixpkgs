{ lib
, buildDunePackage
, tezos-stdlib
, tezos-stdlib-unix
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-clic";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_clic";

  propagatedBuildInputs = [
    tezos-stdlib-unix
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented command-line-parsing combinators";
  };
}
