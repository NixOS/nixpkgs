{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-protocol-environment-packer
, zarith
}:

buildDunePackage {
  pname = "tezos-protocol-environment-sigs";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_protocol_environment";

  minimalOCamlVersion = "4.12";

  postPatch = ''
    ls ./sigs/v0
    cp -f ${zarith}/lib/ocaml/${ocaml.version}/site-lib/zarith/z.mli ./sigs/v1/z.mli
    cp -f ${zarith}/lib/ocaml/${ocaml.version}/site-lib/zarith/z.mli ./sigs/v2/z.mli
    cp -f ${zarith}/lib/ocaml/${ocaml.version}/site-lib/zarith/z.mli ./sigs/v3/z.mli
    sed -i 's/out_channel/Stdlib.out_channel/g' ./sigs/v1/z.mli
    sed -i 's/Buffer/Stdlib.Buffer/g' ./sigs/v1/z.mli
    sed -i 's/out_channel/Stdlib.out_channel/g' ./sigs/v2/z.mli
    sed -i 's/Buffer/Stdlib.Buffer/g' ./sigs/v2/z.mli
    sed -i 's/out_channel/Stdlib.out_channel/g' ./sigs/v3/z.mli
    sed -i 's/Buffer/Stdlib.Buffer/g' ./sigs/v3/z.mli
  '';

  propagatedBuildInputs = [
    tezos-protocol-environment-packer
  ];

  checkInputs = [
    tezos-stdlib
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: restricted typing environment for the economic protocols";
  };
}
