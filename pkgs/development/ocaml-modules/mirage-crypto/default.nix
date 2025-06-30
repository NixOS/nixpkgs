{
  lib,
  fetchurl,
  buildDunePackage,
  ohex,
  ounit2,
  dune-configurator,
  eqaf,
  withFreestanding ? false,
  ocaml-freestanding,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.13";

  pname = "mirage-crypto";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
    hash = "sha256-VDDOPD5AYn0tZ6jez1ZaH2EtOb2zP5t2fDvbYB/1oZY=";
  };

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
  ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs =
    [
      eqaf
    ]
    ++ lib.optionals withFreestanding [
      ocaml-freestanding
    ];

  meta = {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    changelog = "https://raw.githubusercontent.com/mirage/mirage-crypto/refs/tags/v${version}/CHANGES.md";
    license = with lib.licenses; [
      isc # default license
      bsd2 # mirage-crypto-rng-mirage
      mit # mirage-crypto-ec
    ];
    maintainers = with lib.maintainers; [
      sternenseemann
      momeemt
    ];
  };
}
