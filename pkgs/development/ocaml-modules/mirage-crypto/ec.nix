{
  lib,
  buildDunePackage,
  mirage-crypto,
  dune-configurator,
  pkg-config,
  mirage-crypto-rng,
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

buildDunePackage {
  pname = "mirage-crypto-ec";

  inherit (mirage-crypto)
    src
    version
    ;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
  ];
  propagatedBuildInputs = [
    mirage-crypto
    mirage-crypto-rng
  ]
  ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    asn1-combinators
    ohex
    ounit2
    ppx_deriving_yojson
    ppx_deriving
    yojson
  ];

  meta = mirage-crypto.meta // {
    description = "Elliptic Curve Cryptography with primitives taken from Fiat";
  };
}
