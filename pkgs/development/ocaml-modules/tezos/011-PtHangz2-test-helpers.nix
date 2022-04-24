{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
, tezos-client-011-PtHangz2
, tezos-protocol-011-PtHangz2
, tezos-protocol-011-PtHangz2-parameters
, tezos-protocol-environment
, tezos-shell-services
, tezos-stdlib-unix
, tezos-test-helpers
}:

buildDunePackage {
  pname = "tezos-011-PtHangz2-test-helpers";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-base
    tezos-client-011-PtHangz2
    tezos-protocol-011-PtHangz2
    tezos-protocol-011-PtHangz2-parameters
    tezos-protocol-environment
    tezos-shell-services
    tezos-stdlib-unix
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol testing framework";
  };
}
