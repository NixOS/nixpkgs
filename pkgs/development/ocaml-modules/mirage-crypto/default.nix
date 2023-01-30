{ lib, fetchurl, buildDunePackage, ounit2, cstruct, dune-configurator, eqaf, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.10.7";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
    sha256 = "sha256-PoGKdgwjXFtoTHtrQ7HN0qfdBOAQW2gNUk+DbrmIppw=";
  };

  doCheck = true;
  nativeCheckInputs = [ ounit2 ];

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
