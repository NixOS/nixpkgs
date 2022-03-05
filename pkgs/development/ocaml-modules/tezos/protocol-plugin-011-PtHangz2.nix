{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-011-PtHangz2
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-protocol-plugin-011-PtHangz2";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  buildInputs = [
    tezos-protocol-011-PtHangz2
    tezos-protocol-environment
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol plugin";
  };
}
