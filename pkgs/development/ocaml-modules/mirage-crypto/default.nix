{ lib, fetchurl, buildDunePackage, ounit2, dune-configurator, eqaf-cstruct, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.11.3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
    sha256 = "sha256-v7Uw+hac2QXrx+JEnzQHz71nAjrAspG4tvShQ3pdlbE=";
  };

  doCheck = true;
  checkInputs = [ ounit2 ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator  ];
  propagatedBuildInputs = [
    eqaf-cstruct
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  # Compatibility with eqaf 0.10
  postPatch = ''
    substituteInPlace src/dune --replace-warn eqaf.cstruct eqaf-cstruct
  '';

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
