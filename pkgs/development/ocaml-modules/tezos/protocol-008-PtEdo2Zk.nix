{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-protocol-008-PtEdo2Zk";
  inherit (tezos-stdlib) version src useDune2 doCheck;

  preBuild = ''
    rm -rf vendors
    substituteInPlace src/proto_008_PtEdo2Zk/lib_protocol/dune.inc --replace "-nostdlib" ""
  '';

  propagatedBuildInputs = [
    tezos-protocol-compiler
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition";
  };
}
