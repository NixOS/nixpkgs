{ lib
, buildDunePackage
, tezos-stdlib
, tezos-rpc-http
, resto-cohttp-server
, resto-acl
, alcotest-lwt
, tezos-test-helpers
, tezos-base-test-helpers
, cacert
}:

buildDunePackage {
  pname = "tezos-rpc-http-server";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_rpc_http";

  propagatedBuildInputs = [
    tezos-rpc-http
    resto-cohttp-server
    resto-acl
    cacert
  ];

  checkInputs = [
    alcotest-lwt
    tezos-test-helpers
    tezos-base-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented RPCs (http client)";
  };
}
