{ lib
, buildDunePackage
, tezos-stdlib
, tezos-client-base
}:

buildDunePackage {
  pname = "tezos-signer-services";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_signer_services";

  propagatedBuildInputs = [
    tezos-client-base
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-signer`";
  };
}
