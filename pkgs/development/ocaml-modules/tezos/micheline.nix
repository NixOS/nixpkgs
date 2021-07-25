{ lib
, buildDunePackage
, tezos-stdlib
, tezos-error-monad
, uutf
, alcotest
, alcotest-lwt
, ppx_inline_test
}:

buildDunePackage {
  pname = "tezos-micheline";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-error-monad
    uutf
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: internal AST and parser for the Michelson language";
  };
}
