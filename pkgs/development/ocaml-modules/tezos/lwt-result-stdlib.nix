{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-error-monad
, alcotest
, alcotest-lwt
, crowbar
}:

if lib.versionAtLeast ocaml.version "4.12" then
  throw "tezos-lwt-result-stdlib-${tezos-stdlib.version} is not available for OCaml > 4.10"
else

buildDunePackage {
  pname = "tezos-lwt-result-stdlib";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-error-monad
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
    crowbar
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: error-aware stdlib replacement";
  };
}
