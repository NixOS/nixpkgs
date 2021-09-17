{ lib
, buildDunePackage
, tezos-stdlib
, tezos-crypto
, tezos-protocol-environment-packer
}:

buildDunePackage {
  pname = "tezos-protocol-environment-structs";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-crypto
    tezos-protocol-environment-packer
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: restricted typing environment for the economic protocols";
  };
}
