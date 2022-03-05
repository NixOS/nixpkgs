{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-protocol-demo-noops";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/";

  propagatedBuildInputs = [
    tezos-protocol-compiler
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: demo_noops economic-protocol definition";
  };
}
