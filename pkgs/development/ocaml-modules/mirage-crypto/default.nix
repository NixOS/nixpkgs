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
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
    hash = "sha256-CVQrzZbB02j/m6iFMQX0wXgdjJTCQA3586wGEO4H5n4=";
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
