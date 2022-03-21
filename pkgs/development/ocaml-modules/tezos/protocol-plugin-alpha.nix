{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-alpha
}:

buildDunePackage {
  pname = "tezos-protocol-plugin-alpha";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-protocol-alpha
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol plugin";
  };
}
