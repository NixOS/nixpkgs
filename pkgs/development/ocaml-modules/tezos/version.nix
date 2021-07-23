{ lib
, buildDunePackage
, tezos-stdlib
, tezos-base
}:

buildDunePackage {
  pname = "tezos-version";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-base
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: version information generated from Git";
  };
}
