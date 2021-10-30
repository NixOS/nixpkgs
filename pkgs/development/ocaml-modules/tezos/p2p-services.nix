{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-p2p-services";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_p2p_services";

  propagatedBuildInputs = [
    tezos-base
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: descriptions of RPCs exported by `tezos-p2p`";
  };
}
