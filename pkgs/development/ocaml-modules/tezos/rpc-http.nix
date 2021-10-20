{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, resto-directory
, resto-cohttp
}:

buildDunePackage {
  pname = "tezos-rpc-http";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_rpc_http";

  propagatedBuildInputs = [
    tezos-base
    resto-directory
    resto-cohttp
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented RPCs (http server and client)";
  };
}
