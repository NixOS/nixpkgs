{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, lwt
, alcotest-lwt
, tezos-test-helpers
}:

buildDunePackage {
  pname = "tezos-lwt-result-stdlib";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_lwt_result_stdlib";

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [
    lwt
  ];

  checkInputs = [
    alcotest-lwt
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: error-aware stdlib replacement";
  };
}
