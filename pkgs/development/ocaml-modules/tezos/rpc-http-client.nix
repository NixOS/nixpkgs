{ lib
, buildDunePackage
, tezos-stdlib
, tezos-rpc-http
, resto-cohttp-client
}:

buildDunePackage {
  pname = "tezos-rpc-http-client";
  inherit (tezos-stdlib) version;
  src = "${tezos-stdlib.base_src}/src/lib_rpc_http";

  propagatedBuildInputs = [
    tezos-rpc-http
    resto-cohttp-client
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented RPCs (http client)";
  };
}
