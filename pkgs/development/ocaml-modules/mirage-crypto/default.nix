{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, bigarray-compat, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "20915c53ddb658c53f588c414f13676bc8ad3cd734d9ed909225ea080dd8144d";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [
    cstruct eqaf bigarray-compat
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

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
