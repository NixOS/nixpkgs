{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-008-PtEdo2Zk
, qcheck-alcotest
}:

buildDunePackage {
  pname = "tezos-protocol-008-PtEdo2Zk-parameters";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-protocol-008-PtEdo2Zk
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: parameters";
  };
}
