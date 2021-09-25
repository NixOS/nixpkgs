{ lib
, buildDunePackage
, tezos-stdlib
, tezos-stdlib-unix
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-clic";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-stdlib-unix
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented command-line-parsing combinators";
  };
}
