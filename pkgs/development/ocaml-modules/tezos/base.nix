{ lib
, buildDunePackage
, tezos-stdlib
, tezos-crypto
, tezos-micheline
, ptime
, ezjsonm
, ipaddr
, qcheck-alcotest
, crowbar
}:

buildDunePackage {
  pname = "tezos-base";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-crypto
    tezos-micheline
    ptime
    ezjsonm
    ipaddr
  ];

  checkInputs = [
    qcheck-alcotest
    crowbar
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: meta-package and pervasive type definitions for Tezos";
  };
}
