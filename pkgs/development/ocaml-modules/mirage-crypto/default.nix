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
