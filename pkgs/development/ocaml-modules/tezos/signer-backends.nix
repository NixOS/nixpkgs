{ lib
, buildDunePackage
, tezos-stdlib
, tezos-rpc-http-client-unix
, tezos-signer-services
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-signer-backends";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_signer_backends";

  propagatedBuildInputs = [
    tezos-rpc-http-client-unix
    tezos-signer-services
  ];

  checkInputs = [
    alcotest
    alcotest-lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: remote-signature backends for `tezos-client`";
  };
}
