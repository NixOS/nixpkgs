{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-version
, tezos-protocol-environment
, ocp-ocamlres
, pprint
}:

if lib.versionAtLeast ocaml.version "4.13" then
  throw "tezos-protocol-compiler-${tezos-stdlib.version} is not available for OCaml > 4.12"
else

buildDunePackage {
  pname = "tezos-protocol-compiler";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_compiler";

  minimalOCamlVersion = "4.12";

  propagatedBuildInputs = [
    tezos-version
    tezos-protocol-environment
    ocp-ocamlres
    pprint
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: economic-protocol compiler";
  };
}
