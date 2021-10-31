{ lib
, buildDunePackage
, tezos-stdlib
, tezos-protocol-updater
, tezos-protocol-compiler
}:

buildDunePackage {
  pname = "tezos-validation";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_validation";

  propagatedBuildInputs = [
    tezos-protocol-updater
  ];

  buildInputs = [
    tezos-protocol-compiler
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: library for blocks validation";
  };
}
