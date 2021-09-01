{ lib
, buildDunePackage
, tezos-stdlib
, data-encoding
, lwt
, lwt-canceler
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-error-monad";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-stdlib
    data-encoding
    lwt
    lwt-canceler
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: error monad";
  };
}
