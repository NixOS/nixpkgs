{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-crypto
, tezos-rust-libs
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-sapling";
  inherit (tezos-stdlib) version src useDune2 preBuild;

  propagatedBuildInputs = [
    tezos-crypto
    tezos-rust-libs
  ];

  checkInputs = [
    alcotest-lwt
  ];

  doCheck = false;

  # This is a hack to work around the hack used in the dune files
  OPAM_SWITCH_PREFIX = "${tezos-rust-libs}";

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition";
  };
}
