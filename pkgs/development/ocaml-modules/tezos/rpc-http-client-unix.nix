{ lib
, buildDunePackage
, tezos-stdlib
, tezos-rpc-http-client
, cohttp-lwt-unix
}:

buildDunePackage {
  pname = "tezos-rpc-http-client-unix";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_rpc_http";

  propagatedBuildInputs = [
    tezos-rpc-http-client
    cohttp-lwt-unix
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: unix implementation of the RPC client";
  };
}
