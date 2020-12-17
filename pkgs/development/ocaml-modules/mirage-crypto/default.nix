{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, pkg-config }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.8.7";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "1gx86h6kk39zq3kvl854jc2ap2755paalp1f7iv8r9js2xnbxfxy";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [ cstruct eqaf ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
