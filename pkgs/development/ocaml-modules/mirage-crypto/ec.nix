{
  lib,
  buildDunePackage,
  mirage-crypto,
  dune-configurator,
  pkg-config,
  mirage-crypto-rng,
  mirage-crypto-pk,
  alcotest,
  asn1-combinators,
  ohex,
  ounit2,
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
  ];
  propagatedBuildInputs =
    [
      mirage-crypto
      mirage-crypto-rng
    ]
    ++ lib.optionals withFreestanding [
      ocaml-freestanding
    ];

  strictDeps = true;

  doCheck = true;
  checkInputs = [
    alcotest
    asn1-combinators
    ohex
    ounit2
    ppx_deriving_yojson
    ppx_deriving
    yojson
    mirage-crypto-pk
  ];

  meta = mirage-crypto.meta // {
    description = "Elliptic Curve Cryptography with primitives taken from Fiat";
  };
}
