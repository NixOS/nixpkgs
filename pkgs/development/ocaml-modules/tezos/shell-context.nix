{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-shell-context";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_environment";

  propagatedBuildInputs = [
    tezos-protocol-environment
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: economic-protocols environment implementation for `tezos-node`";
  };
}
