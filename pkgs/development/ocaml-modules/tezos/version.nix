{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-version";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_version";

  propagatedBuildInputs = [
    tezos-base
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: version information generated from Git";
  };
}
