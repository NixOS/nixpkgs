{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-protocol-011-PtHangz2";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  buildInputs = [
    tezos-protocol-compiler
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition";
  };
}
