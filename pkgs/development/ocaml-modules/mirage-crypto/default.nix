{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.10.5";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "sha256-eeKMSRZrBiTzWLv80P5LeouPib24uTigk2HLtORKpJU=";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator  ];
  propagatedBuildInputs = [
    cstruct eqaf
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  strictDeps = !doCheck;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = [
      licenses.isc  # default license
      licenses.bsd2 # mirage-crypto-rng-mirage
      licenses.mit  # mirage-crypto-ec
    ];
    maintainers = with maintainers; [ sternenseemann ];
  };
}
