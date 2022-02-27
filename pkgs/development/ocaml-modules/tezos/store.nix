{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-updater
, tezos-validation
, tezos-legacy-store
, tezos-protocol-compiler
, index
, camlzip
, tar-unix
, ringo-lwt
, digestif
, alcotest-lwt
, lwt-watcher
}:

buildDunePackage {
  pname = "tezos-store";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_store";

  propagatedBuildInputs = [
    index
    camlzip
    tar-unix
    ringo-lwt
    digestif
    lwt-watcher
    tezos-protocol-updater
    tezos-validation
    tezos-legacy-store
  ];

  nativeBuildInputs = [
    tezos-protocol-compiler
  ];

  strictDeps = true;

  checkInputs = [
    alcotest-lwt
  ];

  # A lot of extra deps with wide dependency cones needed
  doCheck = false;

  meta = tezos-stdlib.meta // {
    description = "Tezos: custom economic-protocols environment implementation for `tezos-client` and testing";
  };
}
