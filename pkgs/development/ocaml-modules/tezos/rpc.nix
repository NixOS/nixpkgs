{ lib
, buildDunePackage
, tezos-stdlib
, tezos-error-monad
, resto
, resto-directory
}:

buildDunePackage {
  pname = "tezos-rpc";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-error-monad
    resto
    resto-directory
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: library of auto-documented RPCs (service and hierarchy descriptions)";
  };
}
