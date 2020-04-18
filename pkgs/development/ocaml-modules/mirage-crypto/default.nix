{ lib, fetchurl, buildDunePackage, ounit, cstruct, ocplib-endian
, cpuid, dune-configurator, cpuAcceleration ? false }:

buildDunePackage rec {
  minimumOCamlVersion = "4.07";

  pname = "mirage-crypto";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "08xq49cxn66yi0gfajzi8czcxfx24rd191rvf7s10wfkz304sa72";
  };

  useDune2 = true;

  preBuild = ''
    MIRAGE_CRYPTO_ACCELERATE=${lib.boolToString cpuAcceleration}
  '';

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ cpuid dune-configurator ];
  propagatedBuildInputs = [ cstruct ocplib-endian ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
