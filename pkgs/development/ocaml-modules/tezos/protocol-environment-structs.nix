{ lib
, buildDunePackage
, tezos-stdlib
, tezos-crypto
, tezos-protocol-environment-packer
}:

buildDunePackage {
  pname = "tezos-protocol-environment-structs";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_environment";

  propagatedBuildInputs = [
    tezos-crypto
    tezos-protocol-environment-packer
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: restricted typing environment for the economic protocols";
  };
}
