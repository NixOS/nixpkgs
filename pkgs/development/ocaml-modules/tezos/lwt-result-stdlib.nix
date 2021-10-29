{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, lwt
, alcotest
, alcotest-lwt
, tezos-test-helpers
}:

if lib.versionAtLeast ocaml.version "4.12" then
  throw "tezos-lwt-result-stdlib-${tezos-stdlib.version} is not available for OCaml > 4.10"
else

buildDunePackage {
  pname = "tezos-lwt-result-stdlib";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_lwt_result_stdlib";

  propagatedBuildInputs = [
    lwt
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: error-aware stdlib replacement";
  };
}
