{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-protocol-environment
, ocp-ocamlres
, pprint
}:

if lib.versionAtLeast ocaml.version "4.12" then
  throw "tezos-protocol-compiler-${tezos-stdlib.version} is not available for OCaml > 4.10"
else

buildDunePackage {
  pname = "tezos-protocol-compiler";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  minimalOCamlVersion = "4.09";

  propagatedBuildInputs = [
    tezos-protocol-environment
    ocp-ocamlres
    pprint
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: economic-protocol compiler";
  };
}
