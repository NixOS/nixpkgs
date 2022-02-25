{ lib
, buildDunePackage
, tezos-stdlib
, tezos-mockup-registration
, tezos-proxy
, tezos-signer-backends
, tezos-011-PtHangz2
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
    tezos-011-PtHangz2.protocol
    tezos-011-PtHangz2.protocol-parameters
    tezos-011-PtHangz2.protocol-plugin
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
