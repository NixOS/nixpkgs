{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-p2p-services";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-base
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-p2p`";
  };
}
