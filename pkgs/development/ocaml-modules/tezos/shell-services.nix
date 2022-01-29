{ lib
, buildDunePackage
, tezos-stdlib
, tezos-workers
, tezos-p2p-services
, tezos-version
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-shell-services";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_shell_services";

  propagatedBuildInputs = [
    tezos-workers
    tezos-p2p-services
    tezos-version
  ];

  doCheck = true;

  checkInputs = [
    alcotest-lwt
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-shell`";
  };
}
