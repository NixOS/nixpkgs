{ lib
, buildDunePackage
, ocaml
, tezos-stdlib
, tezos-protocol-environment-packer
, zarith
}:

buildDunePackage {
  pname = "tezos-protocol-environment-sigs";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-protocol-environment-packer
  ];

  checkInputs = [
    tezos-stdlib
  ];

  postPatch = ''
    cp -f ${zarith}/lib/ocaml/${ocaml.version}/site-lib/zarith/z.mli ./src/lib_protocol_environment/sigs/v1/z.mli
    sed -i 's/out_channel/Stdlib.out_channel/g' ./src/lib_protocol_environment/sigs/v1/z.mli
    sed -i 's/Buffer/Stdlib.Buffer/g' ./src/lib_protocol_environment/sigs/v1/z.mli
  '';

  meta = tezos-stdlib.meta // {
    description = "Tezos: restricted typing environment for the economic protocols";
  };
}
