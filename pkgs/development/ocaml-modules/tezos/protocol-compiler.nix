{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-protocol-environment
, ocp-ocamlres
, re
, pprint
}:

if lib.versionAtLeast ocaml.version "4.12" then
  throw "tezos-protocol-compiler-${tezos-stdlib.version} is not available for OCaml > 4.10"
else

buildDunePackage {
  pname = "tezos-protocol-compiler";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_compiler";

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    tezos-protocol-environment
    ocp-ocamlres
    re
    pprint
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: economic-protocol compiler";
  };
}
