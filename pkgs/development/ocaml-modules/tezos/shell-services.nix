{ lib
, buildDunePackage
, tezos-stdlib
, tezos-workers
, tezos-p2p-services
, tezos-version
}:

buildDunePackage {
  pname = "tezos-shell-services";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-workers
    tezos-p2p-services
    tezos-version
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-shell`";
  };
}
