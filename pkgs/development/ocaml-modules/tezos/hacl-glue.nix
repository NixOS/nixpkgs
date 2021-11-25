{ lib
, buildDunePackage
, tezos-stdlib
}:

buildDunePackage {
  pname = "tezos-hacl-glue";

  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_hacl_glue/virtual";

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: thin layer of glue around hacl-star (virtual package)";
  };
}
