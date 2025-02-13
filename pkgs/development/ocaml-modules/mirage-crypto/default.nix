{
  lib,
  fetchurl,
  buildDunePackage,
  ohex,
  ounit2,
  dune-configurator,
  eqaf-cstruct,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.13";

  pname = "mirage-crypto";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
    hash = "sha256-URF2S5shFo649RczNGPq0t0W+1gicoh4OihAl5dP+Sg=";
  };

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs =
    [
      eqaf-cstruct
    ]
    ++ lib.optionals withFreestanding [
      ocaml-freestanding
    ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = [
      licenses.isc # default license
      licenses.bsd2 # mirage-crypto-rng-mirage
      licenses.mit # mirage-crypto-ec
    ];
    maintainers = with maintainers; [ sternenseemann ];
  };
}
