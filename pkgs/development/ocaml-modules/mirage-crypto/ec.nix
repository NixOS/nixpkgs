{
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
    knownVulnerabilities = [
      "CVE-2026-87733" # fixed in 2.2.0
      "CVE-2026-87736" # fixed in 2.3.0
      "CVE-2026-87737" # fixed in 2.4.0
    ];
  };
}
