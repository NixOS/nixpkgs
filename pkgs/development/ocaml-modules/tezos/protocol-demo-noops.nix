{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-protocol-demo-noops";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-protocol-compiler
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: demo_noops economic-protocol definition";
  };
}
