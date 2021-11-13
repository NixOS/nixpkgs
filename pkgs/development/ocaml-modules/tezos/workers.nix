{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-workers";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_workers";

  propagatedBuildInputs = [
    tezos-base
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: worker library";
  };
}
