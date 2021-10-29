{ lib
, buildDunePackage
, tezos-stdlib
, tezos-hacl-glue
, ctypes
, hacl-star
}:

buildDunePackage {
  pname = "tezos-hacl-glue-unix";

  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_hacl_glue/unix";

  propagatedBuildInputs = [
    ctypes
    hacl-star
    tezos-hacl-glue
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: thin layer of glue around hacl-star (unix implementation)";
  };
}
