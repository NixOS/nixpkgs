{ lib
, buildDunePackage
, tezos-stdlib
, tezos-mockup-registration
, tezos-proxy
, tezos-signer-backends
, tezos-010-PtGRANAD
, alcotest-lwt
, ppx_inline_test
, cacert
}:

buildDunePackage {
  pname = "tezos-client-010-PtGRANAD";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/proto_010_PtGRANAD/lib_client";

  propagatedBuildInputs = [
    tezos-mockup-registration
    tezos-proxy
    tezos-signer-backends
    tezos-010-PtGRANAD.protocol-parameters
    tezos-010-PtGRANAD.protocol-plugin
    ppx_inline_test
  ];

  checkInputs = [
    alcotest-lwt
    cacert
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos/Protocol: protocol specific library for `tezos-client`";
  };
}
