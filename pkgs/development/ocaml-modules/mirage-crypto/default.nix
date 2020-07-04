{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, pkg-config }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "1wb2923v17z179v866ragil0r601w5b3kvpnbkmkwlijp4i5grih";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [ cstruct ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
