{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-011-PtHangz2
, tezos-protocol-environment
}:

buildDunePackage {
  pname = "tezos-protocol-011-PtHangz2-parameters";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-protocol-011-PtHangz2
    tezos-protocol-environment
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: parameters";
  };
}
