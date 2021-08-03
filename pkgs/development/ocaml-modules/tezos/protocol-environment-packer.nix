{ lib
, buildDunePackage
, tezos-stdlib
}:

buildDunePackage {
  pname = "tezos-protocol-environment-packer";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  minimalOCamlVersion = "4.03";

  meta = tezos-stdlib.meta // {
    description = "Tezos: sigs/structs packer for economic protocol environment";
  };
}
