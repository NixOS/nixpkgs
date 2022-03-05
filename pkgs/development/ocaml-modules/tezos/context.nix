{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, tezos-shell-services
, irmin
, irmin-pack
, digestif
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-context";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_context";

  propagatedBuildInputs = [
    tezos-base
    tezos-shell-services
    irmin
    irmin-pack
    digestif
  ];

  checkInputs = [
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented RPCs (service and hierarchy descriptions)";
  };
}
