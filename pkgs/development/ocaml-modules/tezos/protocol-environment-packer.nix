{ lib
, buildDunePackage
, tezos-stdlib
}:

buildDunePackage {
  pname = "tezos-protocol-environment-packer";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_environment";

  minimalOCamlVersion = "4.03";

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: sigs/structs packer for economic protocol environment";
  };
}
