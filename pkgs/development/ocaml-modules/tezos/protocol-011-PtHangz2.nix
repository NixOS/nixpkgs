{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-compiler
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-protocol-011-PtHangz2";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  nativeBuildInputs = [
    tezos-protocol-compiler
  ];

  buildInputs = [
    tezos-protocol-environment
  ];

  strictDeps = true;

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: economic-protocol definition";
  };
}
