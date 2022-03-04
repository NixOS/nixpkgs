{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-protocol-alpha";
  inherit (tezos-stdlib) version;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-protocol-compiler
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition";
  };
}
