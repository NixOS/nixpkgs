{
  lib,
  ocaml,
  buildDunePackage,
  mirage-crypto,
  dune-configurator,
  pkg-config,
  cstruct,
  mirage-crypto-rng,
  mirage-crypto-pk,
  hex,
  alcotest,
  asn1-combinators,
  ppx_deriving_yojson,
  ppx_deriving,
  yojson,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  pname = "mirage-crypto-ec";

  inherit (mirage-crypto)
    src
    version
    ;

  duneVersion = "3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
  ];
  propagatedBuildInputs =
    [
      cstruct
      mirage-crypto
      mirage-crypto-rng
    ]
    ++ lib.optionals withFreestanding [
      ocaml-freestanding
    ];

  strictDeps = true;

  doCheck = true;
  checkInputs = [
    hex
    alcotest
    asn1-combinators
    ppx_deriving_yojson
    ppx_deriving
    yojson
    mirage-crypto-pk
  ];

  meta = mirage-crypto.meta // {
    description = "Elliptic Curve Cryptography with primitives taken from Fiat";
  };
}
