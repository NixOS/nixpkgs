{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-workers";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-base
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: worker library";
  };
}
