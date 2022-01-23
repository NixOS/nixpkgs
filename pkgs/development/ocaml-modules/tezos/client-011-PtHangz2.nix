{ lib
, buildDunePackage
, tezos-stdlib
, tezos-mockup-registration
, tezos-proxy
, tezos-signer-backends
, tezos-protocol-011-PtHangz2-parameters
, tezos-protocol-plugin-011-PtHangz2
, alcotest-lwt
, cacert
, ppx_inline_test
, qcheck-alcotest
, tezos-base-test-helpers
, tezos-test-helpers
}:

buildDunePackage {
  pname = "tezos-client-011-PtHangz2";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src";

  propagatedBuildInputs = [
    tezos-mockup-registration
    tezos-proxy
    tezos-signer-backends
    tezos-protocol-011-PtHangz2-parameters
    tezos-protocol-plugin-011-PtHangz2
    ppx_inline_test
  ];

  checkInputs = [
    alcotest-lwt
    cacert
    qcheck-alcotest
    tezos-base-test-helpers
    tezos-test-helpers
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol specific library for `tezos-client`";
  };
}
